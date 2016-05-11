var clusterSize = {};
var regionsUnion = []
var selectedMainRegion = [];
var selectedRegions = [];
var selectedCountries = [];
var saveToViewState = false;
$(function() {
    $('#search_input').fastLiveFilter('#search_list');
});
$(document).ready(function() {
    blockme();
    if(preSelectedCountries.length > 0){
        for(var index = 0; index < preSelectedCountries.length; index++){
            saveToViewState = false;
            if(preSelectedCountries[index] !== 'Global'){
                insertInBasket(bimap.val(preSelectedCountries[index]),preSelectedCountries[index],false );
                console.log('[id="selectable-' + bimap.val(preSelectedCountries[index]) + '-' + preSelectedCountries[index] +'"]');
                $('[id="selectable-' + bimap.val(preSelectedCountries[index]) + '-' + preSelectedCountries[index] +'"]').addClass('picked_country');
            }
        }
    }
    if(preSelectedMainRegions.length > 0){
        for(var index = 0; index < preSelectedMainRegions.length; index++){
            saveToViewState = false;
            if(preSelectedMainRegions[index] !== '' && preSelectedMainRegions[index] !== 'Global'){
                selectAllCountriesWithRegion(preSelectedMainRegions[index]);
                insertInBasket(preSelectedMainRegions[index],preSelectedMainRegions[index],true );
            }
        }
    }

    if(preSelectedRegions[0] === 'Global'){
        $('[class="countries_global_checkbox"]').prop('checked', true);
        setAsGlobal();
    }

    if($('.Innovation').is(':checked')) {
        $('.projBrandBrand').attr('disabled', 'disabled');
    }

    if($('.Brand_Led_Growth').is(':checked')) {
        $('.projBrandInnov').attr('disabled', 'disabled');
    }

    $.unblockUI();
});


function setAsGlobal() {
    saveToViewState = true;
    var isChecked = $('[class="countries_global_checkbox"]').is(':checked');
    if (isChecked) {
        $('.ms-elem-selectable').addClass('picked_country');
        $('[id^="region-selectable-"]').removeClass('part_region_selected');
        $('[id^="region-selectable-"]').removeClass('whole_region_selected');
        $('[id^="region-selectable-"] .region_select_info_text').text('');
        $('.basket_region_selected').remove();
        clusterSize = {};
        regionsUnion = [];
        insertInBasket('Global', 'Global');
        $('.ms_basket').addClass('disablebuttons');
    } else {
        $('.ms-elem-selectable').removeClass('picked_country');
        removeFromBasket('Global');
        $('.ms_basket').removeClass('disablebuttons');
        regionsUnion = [];
    }
    //setCountryAndRegion();
}

function insertInBasket(nameOfCluster, nameOfCountry, isClusterBeingInserted) {
    if (clusterSize[nameOfCluster] === undefined) {
        clusterSize[nameOfCluster] = 1;
    } else {
        clusterSize[nameOfCluster] += 1;
    }
    if (isClusterBeingInserted) {
        clusterSize[nameOfCluster] = 0;
        $('.ms_basket li:first').after('<li class="basket_region_selected cluster" id="' + nameOfCluster + '-basket-selection"><span>' + nameOfCountry + '</span></li>');
        
    } else {
        if ($('.basket_region_selected').hasClass('country')) {
            $('.basket_region_selected.country:last-of-type').after('<li class="basket_region_selected country" id="' + nameOfCluster + '-basket-selection"><span>' + nameOfCountry + '</span></li>');
        } else if ($('.basket_region_selected').hasClass('cluster')){
            $('.basket_region_selected.cluster:last-of-type').after('<li class="basket_region_selected country" id="' + nameOfCluster + '-basket-selection"><span>' + nameOfCountry + '</span></li>');
        }else{
            $('.ms_basket_title').after('<li class="basket_region_selected country" id="' + nameOfCluster + '-basket-selection"><span>' + nameOfCountry + '</span></li>');
        }
    }

    if (clusterSize[nameOfCluster] > 0 && !isClusterBeingInserted) {
        $('[id^="region-selectable-' + nameOfCluster + '"]').addClass('part_region_selected');
        $('[id="region-selectable-' + nameOfCluster + '"] .region_select_info_text').text(clusterSize[nameOfCluster]);
    }
    if(nameOfCluster === 'Global'){
        setCampaignScaleOneGlobal();
        regionsUnion.push('Global');
    }else{
        setCountryAndRegion();
    }
}

function removeFromBasket(nameOfCluster, nameOfCountry) {
    if (nameOfCluster === 'Global') {
        $('[id^="' + nameOfCluster + '"]').remove();
        clusterSize = {};
        $('[id^="region-selectable-"]').removeClass('part_region_selected');
        $('[id^="region-selectable-"]').removeClass('whole_region_selected');
        $('[id^="region-selectable-"] .region_select_info_text').text('');
    } else {
        $('[id^="selectable-' + nameOfCluster + '-' + nameOfCountry + '"]').removeClass('picked_country');
        clusterSize[nameOfCluster] -= 1;
        $('[id="region-selectable-' + nameOfCluster + '"] .region_select_info_text').text(clusterSize[nameOfCluster]);
        if (clusterSize[nameOfCluster] === 0) {
            $('[id^="region-selectable-' + nameOfCluster + '"]').removeClass('part_region_selected');
            $('[id="region-selectable-' + nameOfCluster + '"] .region_select_info_text').text('');
        }
    }
}

function removeAllFromBasket() {
    clusterSize = {};
    $('[id^="region-selectable-"]').removeClass('part_region_selected');
    $('[id^="region-selectable-"]').removeClass('whole_region_selected');
    $('[id^="region-selectable-"] .region_select_info_text').text('');
    $('.ms-elem-selectable').removeClass('picked_country');
    $('.basket_region_selected').remove();
    setCountryAndRegion();
    return false;
}

var addClustersListener = $('.ms-elem-selectable.clusters').click(function(e) {
    if ($(this).hasClass('picked_country')) {
        e.preventDefault();
    } else if ($(this).hasClass('whole_region_selected')) {
        e.preventDefault();
    } else if ($(this).hasClass('part_region_selected')) {
        e.preventDefault();
    } else {
        selectAllCountriesWithRegion(this.innerText);
        var cluster = $(this).find('span.regionArea').text();
        var country = cluster;
        saveToViewState = true;
        insertInBasket(cluster, country, true);
    }
    setCountryAndRegion();
});

var addCountriesListener = $('.ms-elem-selectable.countries').click(function(e) {
    if ($(this).hasClass('picked_country')) {
        e.preventDefault();
    } else {
        var country = $(this).find('span.countryArea').text();
        var cluster = $(this).find('span.country_select_info_text').text();
        saveToViewState = true;
        insertInBasket(cluster, country, false);
        $(this).addClass('picked_country');
        $('#search_input').val('');
        $('#search_input').trigger('keydown');
        //$(this).off('click');
    }
    setCountryAndRegion();
});

$('body').on({
    click: function() {
        if ($(this).hasClass('cluster')) {
            var cluster = $(this).attr('id').split('-')[0];
            var country = cluster;
            removeAllCountriesWithRegion(cluster);
            $(this).remove();
            setCountryAndRegion();
        } else {
            var cluster = $(this).attr('id').split('-')[0];
            var country = this.innerText;
            removeFromBasket(cluster, country);
            $(this).remove();
            setCountryAndRegion();
        }
    }
}, '.basket_region_selected');

function selectAllCountriesWithRegion(regionName) {
    clusterSize[regionName] = 0;
    $('[id^="selectable-' + regionName + '"]').addClass('picked_country');
    $('[id^="region-selectable-' + regionName + '"]').addClass('whole_region_selected');
    $('[id^="region-selectable-' + regionName + '"] .region_select_info_text').text('All Countries');
    //$('[id^="selectable-' +regionName +'"]').off('click');
    //$('[id^="region-selectable-"]').off('click');
}

function removeAllCountriesWithRegion(regionName) {
    clusterSize[regionName] = 0;
    $('[id^="selectable-' + regionName + '"]').removeClass('picked_country');
    $('[id^="region-selectable-' + regionName + '"]').removeClass('whole_region_selected');
    $('[id^="region-selectable-' + regionName + '"] .region_select_info_text').text('');
    //$('[id^="selectable-' +regionName +'"]').off('click');
    //$('[id^="region-selectable-"]').off('click');
}

function setCountryAndRegion() {
    selectedMainRegion = [];
    selectedCountries = [];
    selectedRegions = [];
    $('.basket_region_selected').each(function(index, value) {
        if ($(this).hasClass('cluster')) {
            selectedMainRegion.push($(this).attr('id').split('-')[0]);
        } else if ($(this).hasClass('country')) {
            selectedCountries.push(this.innerText);
        }
    });
    $('.ms-elem-selectable.clusters.part_region_selected').each(function(index, value) {
        selectedRegions.push($(this).find('span.regionArea').text());
    });
    //setCampaignScale(selectedCountries.length);
    regionsUnion = _.union(selectedMainRegion, selectedRegions);
    if(saveToViewState){
        setInfoCountries(selectedMainRegion.join(","), regionsUnion.join(","), selectedCountries.join(","));
    }
    //setInfoCountries(regionsUnion.join(","), selectedCountries.join(","));
    console.log('selectedMainRegion : ' + selectedMainRegion);
    console.log('selectedCountries : ' + selectedCountries);
    console.log('selectedRegions : ' + selectedRegions);
    console.log('regionsUnion : ' + regionsUnion);
    saveToViewState = true;
}

function setAgencyHubSplit() {
    var numberOFCountriesSelected = 0;
    var selectedItems = $('[class^="countrySplit_"] option:selected');
    $.each(selectedItems, function(index, value) {
        if (value.text != '-None-') {
            numberOFCountriesSelected = numberOFCountriesSelected + 1;
            console.log(index + ": " + value.text);
        }
    });
    setCampaignScale(numberOFCountriesSelected);
    //counter = numberOFCountriesSelected;
    console.log('Selected Countries' + numberOFCountriesSelected);
}

function incrementCounter(){
    counter += 1;
}

function setInvestmentPriorityInnovationProject() {
    $('.Innovation').attr('checked', true);
    $('.projBrandBrand').attr('disabled', 'disabled');
    $('.projBrandBrand')[0].selectedIndex = 0;
    $('.projBrandInnov').removeAttr('disabled');
}

function setInvestmentPriorityBrandLedGrowth() {
    $('.Brand_Led_Growth').attr('checked', true);
    $('.projBrandBrand').removeAttr('disabled');
    $('.projBrandInnov').attr('disabled', 'disabled');
    $('.projBrandInnov')[0].selectedIndex = 0;
}

function setAgencyHubSplits() {

    var agencySplitHubArray = [];
    var agencySplitHub = {};
    for (var indice = 1; indice < counter + 1; indice++) {
        agencySplitHub.existingId = $(".idSplit_" + indice).text();
        agencySplitHub.countryId = $(".countrySplit_" + indice).val();
        agencySplitHub.splitPercentage = $(".percentageSplit_" + indice).val();
        if(agencySplitHub.countryId !== '' || agencySplitHub.existingId !== ''){
            agencySplitHubArray.push(agencySplitHub);
        }
        agencySplitHub = {};

    }
    var cloneName = $("input[id$=CloneName]").val();
    setAgencyHubAndSavePage(JSON.stringify(agencySplitHubArray), cloneName);
}

function validateCountrySplit() {
    var sum = 0;
    var listItems = '';
    var block = true;
    var validationFail = false;
    var selectedBrandInnov = $(".projBrandInnov").val();
    var selectedBrandBrand = $(".projBrandBrand").val();
    var campaignIdea = $(".projCampaignIdea").val();
    var geographicCoverage = $(".projScale1").val();
    var agencyHub = $(".projScale2").val();
    var isGobal = false;
    $(".percentage").each(function() {
        sum = sum + Number($(this).val());
        //alert(sum);

    });

    console.log('Sum : ' + sum);

    var campaignName = $('input[id$=CampaignName]').length === 1 ? $('input[id$=CampaignName]').val() : $("input[id$=CloneName]").val();

    if (campaignName === 'undefined' || campaignName.length == 0) {
        $('#campaignNameLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#campaignNameLabel').removeClass('mandatory_form_info_missing');
    }
    if (sum != 100) {
        alert('Agency hubsplit values must be equal to 100');
        $('#agencyHubSplitLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#agencyHubSplitLabel').removeClass('mandatory_form_info_missing');
    }
    if (selectedBrandInnov.length == 0 && selectedBrandBrand.length == 0) {
        $('#investmentPriorityLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#investmentPriorityLabel').removeClass('mandatory_form_info_missing');
    }
    if (campaignIdea.length == 0) {
        $('#campaignIdeaLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#campaignIdeaLabel').removeClass('mandatory_form_info_missing');
    }
    if (geographicCoverage.length == 0) {
        $('#geographicCoverage').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#geographicCoverage').removeClass('mandatory_form_info_missing');
    }
    if (agencyHub.length == 0) {
        $('#campaignScaleLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#campaignScaleLabel').removeClass('mandatory_form_info_missing');
    }
    if (regionsUnion.length == 0) {
        $('.campaign_region_picklist').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('.campaign_region_picklist').removeClass('mandatory_form_info_missing');
    }
    if ($(".projBrandInnov").val().length == 0 && $(".projBrandBrand").val().length == 0) {
        $('#innovationLabel').addClass('mandatory_form_info_missing');
        validationFail = true;
    } else {
        $('#innovationLabel').removeClass('mandatory_form_info_missing');
    }
    if (!validationFail) {
        var innovation = $('input[name="innovation"]:checked').val();
        console.dir(innovation);
        console.dir($(".projBrandInnov").val());
        console.dir($(".projBrandBrand").val());
        console.log('Counter Asset : ' + counter);

        /*console.log(agencySplitHubArray);
        if ($('.global_region_picklist input:checked').length === 0) {
            isGlobal = false;
        } else {
            isGlobal = true;
        }*/
        if (!validationFail) {
            setAgencyHubSplits();
            //setCampaignScaleOne(selectedRegions[0]);
        }
        if (validationFail == true) {
            return !validationFail;
        } else {
            return true;
        }
        //setAgencyHub(listItems,isGlobal);
    }
}