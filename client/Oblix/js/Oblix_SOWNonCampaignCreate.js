var key = 0;

$(document).ready(function() {
    initPopover();
});

function initPopover() {
    $("[data-toggle=popover]").popover();
}

function addToActivitySelection(isActivity) {
    var nonCampaignItem = {};
    var validationPass;
    
    if (isActivity) {
        validationPass = validateSelection();
        if(validationPass){

            nonCampaignItem.selectedCountry = $('[id$="country"] option:selected').text();
            nonCampaignItem.selectedActivity = $('[id$="activityId"] option:selected').text();
            nonCampaignItem.selectedAgencyDepartment = $('[id$="agencyDepartment"] option:selected').text();
            nonCampaignItem.selectedRole = $('[id$="selectedRole"] option:selected').text();
            nonCampaignItem.otherName = $('[id$="activityOtherName"]').length !== 0 && $('[id$="activityOtherName"]').val().length > 0  ? $('[id$="activityOtherName"]').val() : "";
            nonCampaignItem.description = $('[id$="activityDescription"]').val();

            if (nonCampaignItem.selectedActivity.toUpperCase() !== 'OTHER') {
                key = sow_id + nonCampaignItem.selectedActivity + nonCampaignItem.selectedCountry + nonCampaignItem.selectedAgencyDepartment + nonCampaignItem.selectedRole;
            } else {
                key = sow_id + nonCampaignItem.selectedActivity + nonCampaignItem.otherName + nonCampaignItem.selectedCountry + nonCampaignItem.selectedAgencyDepartment + nonCampaignItem.selectedRole;
            }
            nonCampaignItem.hourlyRate = $('[id$="hiddenRate"]').text();
            nonCampaignItem.hoursSelected = $('[id$="hoursSelected"]').val();
            nonCampaignItem.totalAmount = nonCampaignItem.hourlyRate * nonCampaignItem.hoursSelected;
            nonCampaignItem.key = key;
            nonCampaignItem.isActivity = true;

            addToWorkList(JSON.stringify(nonCampaignItem));
        } else {
            $.unblockUI();
        }
    } else {
        validationPass = validateResourceSelection();
        if(validationPass){

            nonCampaignItem.selectedCountry = $('[id$="dedicatedCountry"] option:selected').text();
            nonCampaignItem.name = $('[id$="dedicatedResourceName"]').val();
            nonCampaignItem.selectedAgencyDepartment = $('[id$="dedicatedAgencyDepartment"] option:selected').text();
            nonCampaignItem.selectedRole = $('[id$="dedicatedSelectedRole"] option:selected').text();
            //nonCampaignItem.otherName = $('[id$="activityOtherName"]').length !== 0 && $('[id$="activityOtherName"]').val().length > 0  ? $('[id$="activityOtherName"]').val() : "";
            nonCampaignItem.description = $('[id$="resourceDescription"]').val();

            key = sow_id + nonCampaignItem.name + nonCampaignItem.selectedCountry + nonCampaignItem.selectedAgencyDepartment + nonCampaignItem.selectedRole;
            nonCampaignItem.hourlyRate = $('[id$="hiddenDedicatedRate"]').text();
            nonCampaignItem.hoursSelected = $('[id$="prcent"]').val();
            nonCampaignItem.totalAmount = nonCampaignItem.hourlyRate * nonCampaignItem.hoursSelected / 100;
            nonCampaignItem.key = key;
            nonCampaignItem.isActivity = false;

            addToWorkList(JSON.stringify(nonCampaignItem));
        } else {
            $.unblockUI();
        }
    }
    
    return false;
}

function validateSelection(){
    if($('[id$="activityId"] option:selected').text() == '--None--'){
        alert('Please choose Activity');
        return false;
    }
    if($('[id$="country"] option:selected').text() == '-Country-'){
        alert('Please choose Country');
        return false;
    }
    if($('[id$="agencyDepartment"] option:selected').text() == '-Agency Department-'){
        alert('Please choose Agency Department');
        return false;
    }
    if($('[id$="selectedRole"] option:selected').text() == '-Role-'){
        alert('Please choose a Role');
        return false;
    }
    if($('[id$="hoursSelected"]').val() == '' || $('[id$="hoursSelected"]').val() == 0){
        alert('Please Enter number of hours required. \'0\' is not a valid value.');
        return false;
    }
    if($('[id$="activityOtherName"]').val() == ''){
        alert('Please Enter Other Description');
        return false;
    }
    return true;
}

function validateResourceSelection(){
    if($('[id$="dedicatedResourceName"]').val() == ''){
        alert('Please enter a resource name');
        return false;
    }
    if($('[id$="dedicatedCountry"] option:selected').text() == '-Country-'){
        alert('Please choose Country');
        return false;
    }
    if($('[id$="dedicatedAgencyDepartment"] option:selected').text() == '-Agency Department-'){
        alert('Please choose Agency Department');
        return false;
    }
    if($('[id$="dedicatedSelectedRole"] option:selected').text() == '-Role-'){
        alert('Please choose a Role');
        return false;
    }
    if($('[id$="prcent"]').val() == '' || $('[id$="prcent"]').val() == 0){
        alert('Please Enter % of hours required. \'0\' is not a valid value.');
        return false;
    }
    /*if(true){
        blockme();
        insertSelectedResource();
    }*/
    return true;
}

function removeItem(selectedkey){
    console.log('SelectedKey : ' + selectedkey); 
    var returnValue = confirm("Are you sure you want to delete?");
    if(selectedkey != null){
        if(returnValue == true){
            blockme();
            removeItemAction(selectedkey);
        }else{
            return returnValue;
        }
    }
}

function removeSection(sectionName){
    var returnValue = confirm("Are you sure you want to delete?");
    if(sectionName != null){
        if(returnValue == true){
            blockme();
            removeSectionAction(sectionName);
        }else{
            return returnValue;
        }
    }
}

// $(document).ready(function(){
//     $('[id*=activityId] option[value="Other"]').remove();
// });
