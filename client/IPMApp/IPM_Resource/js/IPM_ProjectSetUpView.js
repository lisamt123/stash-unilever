jq(document).ready(function() {
	jq('.ccCheck').change(function(e) {
		if (jq('.brandposList input[type=checkbox]:checked').length > 20) {
			jq(this).prop('checked', false);
			jq(this).next('label').removeClass('selected');
		}
	});
	jq(".imageBorder").hover(function() {
		jq('.imgHoverContainer').stop();
		jq('.imgHoverContainer').show(200);

	}, function() {
		jq('.imgHoverContainer').stop();
		jq('.imgHoverContainer').hide(100);
	});
	jq(document).on('click', '.imgDelButton', function(e) {
		e.preventDefault ? e.preventDefault() : e.returnValue = false;
		jq('#deleteImgPop .modal-dialog').width('600px');
		jq('#deleteImgPop .modal-dialog').height('170px');
		jq('#deleteImgPop .modal-dialog').css({
			'margin-top': '10%',
			'z-index': '999'
		});
	});
	jq(".brandautocomplete").autocomplete({
		source: apexAccountList,
		select: function(event, ui) {
			selectedObj = ui.item;
		},
		minLength: 1
	});
	jq('.oprtnRadiobtn  input[type=radio]').each(function(e) {
		jq(this).click(function() {
			var selectedSubProjectType = jq(this).attr("value");
			jq(".oprtnToolTipMsg").hide();
			jq('.oprtnRadiobtn').parents('.oprtnRadioContainer').children('.oprtnToolTipMsg').each(function(e) {
				if (jq(this).attr('selectedValue') == selectedSubProjectType) {
					jq(this).show();
				}
			});
		});
	});
	jq('.oprtnRadiobtn input[type=radio]').each(function() {
		var selectedSubProjectType = jq('.oprtnRadiobtn input[type=radio]:checked').attr("value");
		jq('.oprtnRadiobtn').parents('.oprtnRadioContainer').children('.oprtnToolTipMsg').each(function(e) {
			if (jq(this).attr('selectedValue') == selectedSubProjectType) {
				jq(this).show();
			}
		});
	});
	jq('.gateKeepingModel  input[type=radio]').each(function(e) {
		jq(this).click(function() {
			var selectedGKModel = jq(this).attr("value");
			jq(".gateKModel").hide();
			jq('.gateKeepingModel').parents('.oprtnRadioContainer').children('.gateKModel').each(function(e) {
				if (jq(this).attr('selectedValue') == selectedGKModel) {
					jq(this).show();
				}
			});
		});
	});
	jq('.gateKeepingModel input[type=radio]').each(function() {
		var selectedGKModel = jq('.gateKeepingModel input[type=radio]:checked').attr("value");
		jq('.gateKeepingModel').parents('.oprtnRadioContainer').children('.gateKModel').each(function(e) {
			if (jq(this).attr('selectedValue') == selectedGKModel) {
				jq(this).show();
			}
		});
	});
	jq('.gcltquestions  input[type=radio]').each(function(e) {
		jq(this).click(function() {
			var selectedSubProjectType = jq(this).attr("value");
			jq(".charterTipMsg").hide();
			jq('.gcltquestions').parents('.oprtnRadioContainer').children('.charterTipMsg').each(function(e) {
				if (jq(this).attr('selectedValue') == selectedSubProjectType) {
					jq(this).show();
				}
			});
		});
	});
	jq('.gcltquestions input[type=radio]').each(function() {
		var selectedSubProjectType = jq('.gcltquestions input[type=radio]:checked').attr("value");
		jq('.gcltquestions').parents('.oprtnRadioContainer').children('.charterTipMsg').each(function(e) {
			if (jq(this).attr('selectedValue') == selectedSubProjectType) {
				jq(this).show();
			}
		});
	});
	jq('.yellowBox .ipmRadioButton input[type=radio]').each(function(i) {
		var rdChecked = jq('.yellowBox .ipmRadioButton input[type=radio]:checked').attr("value").split(" ");
		var rdData = rdChecked[0];
		jq("#" + rdData).show();
	});
	jq(document).on('show.bs.dropdown', '.brandposListContainer', function() {
		jq(this).find('.brandposList').show();
	});
	jq(document).click(function(e) {
		if (e.target.id != 'brandposListUL') {
			jq(".brandposList").hide();
		}
	});
	jq('.ipmDropbuttonscc').click(function(e) {
		var brandPositionValue = '';
		jq(".brandposList  input[type=checkbox]").each(function(e) {
			if (jq(this).prop('checked') == true) {
				if (brandPositionValue.length > 0) {
					brandPositionValue = brandPositionValue + ',' + jq(this).val();
				} else {
					brandPositionValue = jq(this).val();
				}
			}
		});
		jq('.hiddenBrand').val(brandPositionValue);
		if (brandPositionValue == '') {
			jq('.brandSelValues').text('{!$Label.IPM_ProjectSetup_SELECT}');
		} else {
			jq('.brandSelValues').text(brandPositionValue);
		}
		jq(".brandposList").hide();
	});
	jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e) {
		e.stopPropagation();
		jq(".brandposList input:checkbox").each(function() {
			jq(this).prop('checked', false);
			jq(this).next('label').removeClass('selected');
			jq('.brandSelValues').text('{!$Label.IPM_ProjectSetup_SELECT}');
		});
	});
	if (jq('.hiddenBrand') != null && jQuery.type(jq('.hiddenBrand')) != 'undefined') {
		var brandPicklist = jq('.hiddenBrand').val();
		if (jQuery.type(brandPicklist) != "undefined" && brandPicklist.length > 0) {
			jq('.brandSelValues').text(brandPicklist);
			var brandArray = brandPicklist.split(',');
			jq(".brandposList  input[type=checkbox]").each(function(e) {
				var checkboxObj = jq(this);
				jq.each(brandArray, function(i, savedBrandPosition) {
					if (checkboxObj.val() === savedBrandPosition) {
						checkboxObj.prop('checked', true);
						return false;
					}
				});
			});
		}
	}
	jq(document).on('click', '.brandposList input[type="checkbox"], .brandposList li', function(e) {
		e.stopPropagation();
	});
	jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
	jq('#ipmGetStartedTab .ipmStartedTabs li:first').addClass('active');
	jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent:first').show();
});
ipmModal('#editMilestone', 'Edit Milestone', '30%', '65%', '2%');
ipmModal('#editTask', 'Edit To-do\'s', '38%', '580px', '2%');
jq('.proRoute input[type=radio]').each(function(e) {
	jq(this).click(function() {
		var redData1 = jq(this).attr("value").split(" ");
		var actData1 = redData1[0];
		jq(".routeTip").hide();
		jq('.proRoute ').parent('.yellowBox').find("#" + actData1).show();
	});
});
var displayTasks = jq('#displayTasksChkBox').attr('isChecked');
var internal = "Internal";
if (displayTasks == internal) {
	jq('#displayTasksChkBox').prop('checked', true);
	jq('.ipmCheckbox #displayTasksChkBox label').addClass('selected');
}
var complexity = jq('.yellowBox .ipmRadioButton input[type=radio]').attr('ischecked');
var full = "Full";
if (complexity == full) {
	jq('#full').prop('checked', true);
} else {
	jq('#lite').prop('checked', true);
}
jq(document).on('click', '.actionBox', function() {
	var url = jq(this).attr('value');
	window.top.location.href = url;
});
function backTab(belem) {
	jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
	var getClass = jq(belem).attr('class').split(' ');
	var getId = getClass[0];
	if (unsaved) {
		if (getId == 'projectdetails') {
			window.parent.location.href = "/apex/IPM_ProjectSetupView?Pid={!projectId}&Projectid=projectdetails";
		}
	} else {
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li." + getId).addClass('active');
		jq('#' + getId).fadeIn("fast");
	}
}
function custnextTab(celem) {
	jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
	var getClass = jq(celem).attr('class').split(' ');
	var getId = getClass[0];
	jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
	jq("#ipmGetStartedTab .ipmStartedTabs li." + getId).addClass('active');
	jq('#' + getId).fadeIn("fast");
}
function skipTab(selem) {
	jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
	var getClass = jq(selem).attr('class').split(' ');
	var getId = getClass[0];
	jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
	jq("#ipmGetStartedTab .ipmStartedTabs li." + getId).addClass('active');
	jq('#' + getId).fadeIn("fast");
}
function selectNextTab(elem) {
	
	if ({!saveSuccess} == true) {
		setTimeout(function() {
			setSlider(1);
		}, 500);
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		var getClass = jq(elem).attr('class').split(' ');
		var getId = getClass[0];
		// alert('getId:' +getId);
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li." + getId).addClass('active');
		jq('#' + getId).fadeIn("fast");
	}
}
jq(document).on('click', '.uploadImage', function(e) {
	e.preventDefault ? e.preventDefault() : e.returnValue = false;
	var url = jq(this).attr('value');
	cppageunsaved = false;
	jq('#ipmUploadImage .modal-title').html('Upload Image');
	jq("#ipmUploadImage .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
	jq('#ipmUploadImage .modal-dialog').addClass('uploadImages');
});
jq(window).load(function() {
	jq('.cust-overlay').hide();
	if (window.location.search.indexOf('TeamMemid=teammembers') > -1) {
		jq('.cust-overlay').fadeOut();
		jq('#ipmModalGetStarted').modal('show');
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li.teammembers").addClass('active');
		jq('#teammembers').fadeIn("fast");
	}
});
jq(window).load(function() {
	jq('.cust-overlay').hide();
	if (window.location.search.indexOf('Milestoneid=milestones') > -1) {
		jq('.cust-overlay').fadeOut();
		jq('#ipmModalGetStarted').modal('show');
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li.milestones").addClass('active');
		jq('#milestones').fadeIn("fast");
	}
});
jq(window).load(function() {
	jq('.cust-overlay').hide();
	if (window.location.search.indexOf('Projectid=projectdetails') > -1) {
		jq('.cust-overlay').fadeOut();
		jq('#ipmModalGetStarted').modal('show');
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li.projectdetails").addClass('active');
		jq('#projectdetails').fadeIn("fast");
	}
});
jq(window).load(function() {
	jq('.cust-overlay').hide();

	if (window.location.search.indexOf('TodoId=todos') > -1 && {
			!isTaskgenerated
		} == true) {
		jq('.cust-overlay').fadeOut();
		jq('#ipmModalGetStarted').modal('show');
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li.todos").addClass('active');
		jq('#todos').fadeIn("fast");
	}
});
jq(window).load(function() {
	jq('.cust-overlay').hide();
	if (window.location.search.indexOf('coreId=coreparameters') > -1) {
		setTimeout(function() {
			setSlider(1);
			sliderCP('.slide-bar');
		}, 500);
		jq('.cust-overlay').fadeOut();
		jq('#ipmModalGetStarted').modal('show');
		jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
		jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
		jq("#ipmGetStartedTab .ipmStartedTabs li.coreparameters").addClass('active');
		jq('#coreparameters').fadeIn("fast");
	}
});

function closepopupupload() {
	window.parent.location.href = "/apex/IPM_ProjectSetupView?Pid={!projectId}&Projectid=projectdetails";
}

function goToHomePage() {
	if ('{!project.IPM_Project_Job_Status__c}' == 'Eligible For Processing' || '{!project.IPM_Project_Job_Status__c}' == 'Processing') {
		setTimeout(function() {
			setSlider(1);
		}, 1000);
		window.parent.location.href = "/apex/IPM_ProjectSetupView?Pid={!projectId}";
	}
}

function goTocoreparameters() {
	if ({!saveSuccess} == true) {
		setTimeout(function() {
			setSlider(1);
		}, 500);
		window.parent.location.href = "/apex/IPM_ProjectSetupView?Pid={!projectId}&coreId=coreparameters";
	}
}
jq(document).on('click', '.addMstoneContainer', function(e) {
	e.preventDefault ? e.preventDefault() : e.returnValue = false;
	var url = jq(this).attr('value');
	jq("#ipmaddMstonWizard .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
	jq('#ipmaddMstonWizard .modal-dialog').addClass('mstoneWizardcss');
});
jq(document).on('click', '.tabTaskButton', function(e) {
	e.preventDefault ? e.preventDefault() : e.returnValue = false;
	var url = jq(this).attr('value');
	jq("#ipmMstoneTaskWizard .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
	jq('#ipmMstoneTaskWizard .modal-dialog').addClass('mtaskwizardcss');
});

var pageScrollTop = jq(window).scrollTop();

function openEditModal(elem) {
	var url = jq(elem).attr('value');
	var top = jq(elem).closest('tr').offset().top - pageScrollTop;
	jq('#ipmModalEdit').modal({
		show: true,
		keyboard: false,
		backdrop: 'static'
	});
	jq("#ipmModalEdit .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
	jq("#ipmModalEdit .modal-body").height('100%');
	jq('#ipmModalEdit .modal-dialog').css('margin-top', top);
	jq('#ipmModalEdit .modal-title').html('Edit Milestone');
	jq('#ipmModalEdit .modal-dialog').addClass('editMstonecss');
}