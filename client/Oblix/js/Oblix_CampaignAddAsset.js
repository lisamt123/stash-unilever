$(function() {
    if (window.location.search.indexOf('&') > -1) {
        if (GetURLParameter('assetId') != undefined) {
            openAsset()
        }
    }
});

function setMendatory(x) {

    if (x.parent().parent().find("span").find("select").val() == '') {
        alert('Asset name can\'t be null');
        return false;
    }

    if (x.parent().parent().find("span").find("select").val() == 'Other' && x.parent().parent().find(".trDescribe").find(".descMend").val() == '') {
        x.find(".error").css("display", "block");
        alert('Please give description ');
        return false;
    } else {
        return true;
    }
}

function showhideDetail(x, optionSelected, projectId) {
    var optionSelection = [];
    var optionSelectionText = "";
    var optionSelectionNumber;

    optionSelectionText = x.parent().parent().parent().parent().find('.optionSelectionClass').text();
    optionSelection = optionSelectionText.split(" ");
    optionSelectionNumber = optionSelection[1];
    var details = {
        quantity: x.parent().parent().parent().find('.assetQuantity').val(),
        location: x.parent().parent().parent().find('.descMend').val(),
        asset_Picklist: x.parent().parent().parent().find('select').last().find('option:selected').text(),
        additional_Description: x.parent().parent().parent().find('.assetNotes').val(),
        option_Name: 'Option ' + optionSelectionNumber
    }
    if (x.val() == 'Other') {
        x.parent().parent().find(".trDescribe").removeAttr("style");
        x.parent().parent().parent().find(".quantselector").addClass("add_assets_other_box_spacing");

    existsInBasket(x.val() + projectId + 'Option' + optionSelectionNumber+details.location);

    } else {
        x.parent().parent().find(".trDescribe").css("display", "none");
        if(x.parent().parent().parent().find(".quantselector").hasClass("add_assets_other_box_spacing")){
            x.parent().parent().parent().find(".quantselector").removeClass("add_assets_other_box_spacing");
        }
        existsInBasket(x.val() + projectId + 'Option' + optionSelectionNumber);        
    }
    blockme();
    return false;
}

function GetURLParameter(sParam) {

    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) {
            return sParameterName[1];
        }
    }
}
var addAsset = function(btn, subCategory, recordType) {
    var button = $(btn);
    var optionSelection = [];
    var scoreSelection = [];
    var optionSelectionText = "";
    var optionSelectionNumber;
    var scoreSelectionNumber;
    var score = button.parent().parent().parent().parent().parent().parent().parent().parent().parent().parent().find(".accordion_body_options.active a").attr("title");
    scoreSelection = score.split(" ");
    scoreSelectionNumber = scoreSelection[1];
    optionSelectionText = button.parent().parent().parent().parent().parent().find('.optionSelectionClass').text();
    optionSelection = optionSelectionText.split(" ");
    optionSelectionNumber = optionSelection[1];
    var details = {
        quantity: button.parent().parent().parent().find('.assetQuantity').val(),
        location: button.parent().parent().parent().find('.descMend').val(),
        asset_Picklist: button.parent().parent().parent().find('select').last().find('option:selected').text(),
        additional_Description: button.parent().parent().parent().find('.assetNotes').val(),
        option_Name: optionSelectionNumber
    }
    console.log("optionSelectionNumber : " + optionSelectionNumber);
    console.log("subCategory : " + subCategory);
    console.log("recordType : " + recordType);
    console.log("scoreSelectionNumber : " + scoreSelectionNumber);
    console.log("details : " + details);
    console.log("details.asset_Picklist : " + details.asset_Picklist);
    setToProjectAction(recordType, subCategory, scoreSelectionNumber, optionSelectionNumber, details.additional_Description, details.location, details.quantity, details.asset_Picklist);
    return true;
}

var updateAsset = function(btn, selectioncounter) {
    blockme();
    var button = $(btn);
    var assetId = button.attr('data-asset-id');
    var options = button.parent().find('.subCatPicklist');
    var optionSelection = [];
    var optionSelectionText = "";
    var optionSelectionNumber;

    optionSelectionText = button.parent().parent().parent().parent().parent().find('.optionSelectionClass').text();
    optionSelection = optionSelectionText.split(" ");
    optionSelectionNumber = optionSelection[1];
    var subCat;
    options.find('option').each(function(index, el) {
        if ($(el).attr("selected") == 'selected') {
            subCat = $(el).val();
            console.dir(' subCat  ' + subCat);
        }
    });
    console.log(button.closest("[id$='assetNamePicklist']"));
    console.log(button.closest(".assetQuantity"));
    console.log(button.parent().parent().parent().find('.assetQuantity').val());
    var details = {
        quantity: button.parent().parent().parent().find('.assetQuantity').val(),
        location: button.parent().parent().parent().find('.descMend').val(),
        asset_Picklist: button.parent().parent().parent().find('select').last().find('option:selected').text(),
        additional_Description: button.parent().parent().parent().find('.assetNotes').val(),
        option_Name: 'Option ' + optionSelectionNumber
    }

    Oblix_CampaignAddAssetController.UpdateProjectAction(assetId, details, function(data, event) {
        button.addClass('hide_button');
        button.siblings('input[type="button"]').removeClass('hide_button');
        refreshAsset(assetId);
    });
}
var removeAsset = function(assetName, projectId) {
    blockme();
    Oblix_CampaignAddAssetController.removeAsset(assetName, projectId, function(data, event) {
        if (event.status) {
            refreshAsset();
        }
    });
};

var getAssetDetails = function(assetId) {
    var deferred = $.Deferred();
    Oblix_CampaignAddAssetController.getAssetDetails(assetId, function(assetDetails, event) {
        deferred.resolve({
            data: assetDetails,
            status: event
        });
    });
    return deferred.promise();
}

//Edit Asset : 

var editAsset = function(el, assetId) {
    //debugger;
    var assetDetails = getAssetDetails(assetId);
    assetDetails.then(function(data) {
        if (data.status.status) {

            var assetName = data.data.assetTitle;
            var assetPicklist = data.data.assetName;
            var projectId = data.data.projectId;
            var optionName = data.data.optionName;
            var location;
            if(data.data.location !== undefined){
                location = data.data.location;
            }else{
                location = '';
            }

            var properties = assetName.split(' X ');
            var numberOfQuantity = properties[0];
            var selectedAbreviation = properties[1].split('-');
            var allAbreviation = JSON.parse(sessionStorage.getItem('assestAbreviations'));

            var firstOption = null;
            var secondOption = null;
            var thirdOption = selectedAbreviation[2];
            var firstElement = null;
            var secondElement = null;
            var thirdElement = null;
            var selectorDetailPanel = null;
            var options = null;
            Object.keys(allAbreviation).forEach(function(key) {
                var currentAbraviation = allAbreviation[key];
                //debugger;
                if (currentAbraviation === selectedAbreviation[0] + '-' + selectedAbreviation[1]) {
                    //debugger;
                    options = key.split('_');
                }
                /*else if(currentAbraviation === selectedAbreviation[1]){
                               secondOption = key;
                             }*/
            })

            firstOption = options[0];
            secondOption = options[1];
            var sel1;
            $('.panel-group').find('.panel-default').find('.panel-heading').each(function(index, el) {
                $(el).parent().find('.panel-collapse').removeClass('in');
                if ($(el).text().search(firstOption) !== -1) {
                    firstElement = $(el);
                    //console.dir('### first elmnt une seul fois :'+firstElement.html());
                    var secondSearchArray = firstElement.next().first().find('div[id*="_tabs"]').children('ul');
                    //console.dir('### secondSearchArray :'+secondSearchArray.html());
                    secondSearchArray.find('a').each(function(index2, el) {
                        if ($(el).text().search(secondOption) !== -1) {
                            secondElement = $(el);
                            var curentIndex = index2 + 1;
                            var selector1 = 'div[id*="_tabs-' + curentIndex + '"]';
                            var selector2 = 'a[href*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                            sel1 = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                            thirdElement = secondSearchArray.find(selector2);
                            selectorDetailPanel = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                        }
                    });
                }
            });

            if (firstElement && !firstElement.parent().find('.panel-collapse').hasClass('in')) {
                //firstElement.parent().find('.panel-collapse').addClass('in');
                firstElement.parent().find('.panel-collapse').collapse('toggle');
            }else{
                firstElement.parent().find('.panel-collapse').addClass('in');
            }

            if (secondElement && secondElement.find('a').attr('tabindex') !== '0') {
                secondElement.trigger('click');
            }

            thirdElement.parent().parent().find('.active').removeClass('active');
            thirdElement.parent().addClass(' active');


            var detailPanel = thirdElement.closest('ul').parent().next().find(sel1);
            thirdElement.closest('ul').parent().next().find('.active').removeClass('active');
            thirdElement.closest('ul').parent().next().find(sel1).addClass(' active');

            detailPanel.find('span').find('.col-lg-6').find('select').val(data.data.assetName);
            if(data.data.assetName === 'Other'){
                detailPanel.find('span').find('.col-lg-4').find('.quantselector').addClass('add_assets_other_box_spacing');
            }else{
                if(detailPanel.find('span').find('.col-lg-4').find('.quantselector').hasClass('add_assets_other_box_spacing')){
                    detailPanel.find('span').find('.col-lg-4').find('.quantselector').removeClass('add_assets_other_box_spacing')
                }
            }
            detailPanel.find('span').find('.col-lg-6').find('.descMend').val(data.data.location);
            detailPanel.find('span').find('.col-lg-6').find('.assetQuantity').val(data.data.quantity);
            detailPanel.find('span').find('.col-lg-6').find('.assetNotes').val(data.data.additionalDescription);
            //detailPanel.find('span').find('.col-lg-6').find('input[type="submit"]').removeClass('hide_button').attr('data-asset-id', assetId);
            //detailPanel.find('span').find('.col-lg-6').find('input[type="button"]').addClass('hide_button').attr('data-asset-id', assetId);
            existsInBasket(assetPicklist + projectId + optionName + location);
            detailPanel.find('span').find('.col-lg-6').find('input[type="submit"]').attr('data-asset-id', assetId);
            
            if (data.data.assetName == "Other") {
                detailPanel.find('span').find('.col-lg-6').find('.trDescribe').css({
                    "display": "block"
                });
            }
        }
    }, function(err) {

    });


}

var openAsset = function() {
    var assetId = GetURLParameter('assetId');
    var assetDetails = getAssetDetails(assetId);
    assetDetails.then(function(data) {
        if (data.status.status) {
            var assetName = data.data.assetTitle;
            var assetPicklist = data.data.assetName;
            var projectId = data.data.projectId;
            var optionName = data.data.optionName;
            var location;
            if(data.data.location !== undefined){
                location = data.data.location;
            }else{
                location = '';
            }
            var properties = assetName.split(' X ');
            var numberOfQuantity = properties[0];
            var selectedAbreviation = properties[1].split('-');
            var allAbreviation = JSON.parse(sessionStorage.getItem('assestAbreviations'));
            var firstOption = null;
            var secondOption = null;
            var thirdOption = selectedAbreviation[2];
            console.dir('## selectedAbreviation[2] : ' + selectedAbreviation[2]);
            var firstElement = null;
            var secondElement = null;
            var thirdElement = null;
            var selectorDetailPanel = null;
            var options = null;
            Object.keys(allAbreviation).forEach(function(key) {
                var currentAbraviation = allAbreviation[key];
                if (currentAbraviation === selectedAbreviation[0] + '-' + selectedAbreviation[1]) {
                    options = key.split('_');

                }
            })
            firstOption = options[0];
            secondOption = options[1];
            var sel1;
            $('.panel-group').find('.panel-default').find('.panel-heading').each(function(index, el) {

                if ($(el).text().search(firstOption) !== -1) {
                    firstElement = $(el);
                    console.dir('### first elmnt une seul fois :' + firstElement.html());
                    var secondSearchArray = firstElement.next().first().find('div[id*="_tabs"]').children('ul');
                    console.dir('### secondSearchArray :' + secondSearchArray.html());
                    secondSearchArray.find('a').each(function(index2, el) {
                        if ($(el).text().search(secondOption) !== -1) {
                            secondElement = $(el);
                            var curentIndex = index2 + 1;
                            var selector1 = 'div[id*="_tabs-' + curentIndex + '"]';
                            var selector2 = 'a[href*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                            sel1 = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                            thirdElement = secondSearchArray.find(selector2);
                            selectorDetailPanel = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
                        }
                    });
                }
            });

            if (firstElement && !firstElement.parent().find('.panel-collapse').hasClass('in')) firstElement.parent().find('.panel-collapse').addClass('in');

            if (secondElement && secondElement.find('a').attr('tabindex') !== '0') secondElement.trigger('click');

            thirdElement.parent().parent().find('.active').removeClass('active');
            thirdElement.parent().addClass(' active');


            var detailPanel = thirdElement.closest('ul').parent().next().find(sel1);
            thirdElement.closest('ul').parent().next().find('.active').removeClass('active');
            thirdElement.closest('ul').parent().next().find(sel1).addClass(' active');

            detailPanel.find('span').find('.col-lg-6').find('select').val(data.data.assetName);
            if(data.data.assetName === 'Other'){
                detailPanel.find('span').find('.col-lg-4').find('.quantselector').addClass('add_assets_other_box_spacing');
            }else{
                if(detailPanel.find('span').find('.col-lg-4').find('.quantselector').hasClass('add_assets_other_box_spacing')){
                    detailPanel.find('span').find('.col-lg-4').find('.quantselector').removeClass('add_assets_other_box_spacing')
                }
            }
            detailPanel.find('span').find('.col-lg-6').find('.descMend').val(data.data.location);
            detailPanel.find('span').find('.col-lg-6').find('.assetQuantity').val(data.data.quantity);
            detailPanel.find('span').find('.col-lg-6').find('.assetNotes').val(data.data.additionalDescription);
            //detailPanel.find('span').find('.col-lg-6').find('input[type="submit"]').removeClass('hide_button').attr('data-asset-id', assetId);
            //detailPanel.find('span').find('.col-lg-6').find('input[type="button"]').addClass('hide_button').attr('data-asset-id', assetId);
            existsInBasket(assetPicklist + projectId + optionName + location);
            detailPanel.find('span').find('.col-lg-6').find('input[type="submit"]').attr('data-asset-id', assetId);
            if (data.data.assetName == "Other") {
                detailPanel.find('span').find('.col-lg-6').find('.trDescribe').css({
                    "display": "block"
                });
            }
        }
    }, function(err) {

    });

}

var getAbreviationForCardAssets = function() {
    Oblix_CampaignAddAssetController.getAbreViationByRTBySubCatgForCardAssets(function(data, event) {
        if (event.status) {
            sessionStorage.setItem('assestAbreviations', JSON.stringify(data));
        }
    });
}
getAbreviationForCardAssets();

// Sticky basket
$(document).ready(function() {
    $("#sticker").sticky({
        topSpacing: 0
    });
});