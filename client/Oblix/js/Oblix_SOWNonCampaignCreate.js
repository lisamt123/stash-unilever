var key = 0;

function addToActivitySelection() {
    var nonCampaignItem = {};
    var validationPass;
    nonCampaignItem.selectedCountry = $('[id$="country"] option:selected').text();
    nonCampaignItem.selectedActivity = $('[id$="activityId"] option:selected').text();
    nonCampaignItem.selectedAgencyDepartment = $('[id$="agencyDepartment"] option:selected').text();
    nonCampaignItem.selectedRole = $('[id$="selectedRole"] option:selected').text();
    nonCampaignItem.otherName = $('[id$="dedicatedResourceOther"]').length !== 0 && $('[id$="dedicatedResourceOther"]').val().length > 0  ? $('[id$="dedicatedResourceOther"]').val() : "";
    validationPass = validateSelection();
    if(validationPass){
        key = sow_id + nonCampaignItem.selectedActivity + nonCampaignItem.selectedCountry + nonCampaignItem.selectedAgencyDepartment + nonCampaignItem.selectedRole;
        nonCampaignItem.hourlyRate = $('[id$="rate"]').text();
        nonCampaignItem.hoursSelected = $('[id$="hoursSelected"]').val();
        nonCampaignItem.totalAmount = nonCampaignItem.hourlyRate * nonCampaignItem.hoursSelected;
        nonCampaignItem.key = key;
        addToActivitySelectionMap(JSON.stringify(nonCampaignItem));
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
    if($('[id$="hoursSelected"]').val() == ''){
        alert('Please Enter number of hours required');
        return false;
    }
    if($('[id$="dedicatedResourceOther"]').val() == ''){
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
    if($('[id$="prcent"]').val() == ''){
        alert('Please Enter % of hours required');
        return false;
    }
    if(true){
        blockme();
        insertSelectedResource();
    }
    return true;
}

function removeRow(selectedkey){
    console.log('SelectedKey : ' + selectedkey); 
    var returnValue = confirm("Are you sure you want to Delete?");
    if(selectedkey != null){
        if(returnValue == true){
            removeFromSelectionMap(selectedkey);
        }else{
            return returnValue;
        }
    }
}

function basketRemoveRow(basketName){
    var returnValue = confirm("Are you sure you want to Delete?");
    if(basketName != null){
        if(returnValue == true){
            removeItemFromBasketList(basketName);
        }else{
            return returnValue;
        }
    }
}