//global variable, local copy of basket on server side
var basket;
//global variable set on "X" click and reset in handleBasketChange()
var assetToBeRemovedMDMId;

var validationMessage;

$(document).ready(function() {
    initBasketMap();

    //ensure any open panels are closed before showing selected
    $('#accordion').on('show.bs.collapse', function() {
        $('#accordion .in').collapse('hide');
    });

    //Handle type changes
    $('.oblix-type-navigation.panel').on('shown.bs.collapse', function(e) {
        handleNavigationChange();
    });

    //Hanle sub-category & option changes
    $('.oblix-sub-category-navigation a[data-toggle="tab"]').on('shown.bs.tab', function(e) {
        handleNavigationChange();
    });

    $('select.asset-selector').change(function() {
        handleNavigationChange();
    });

    var initWithAssetMDMId = $('#initWithAssetMDMId').val();
    if (typeof initWithAssetMDMId != 'undefined' && initWithAssetMDMId != null && initWithAssetMDMId !== "") {
        console.log('initWithAssetMDMId');
        focusOnAsset(initWithAssetMDMId);
    } else {
        handleNavigationChange();
    }

});

var focusOnAsset = function(mdmId) {

    var index = convertAssetMDMIdToIndex(mdmId);
    var table_Indexes = index.split('_');
    var targetTypeTab = table_Indexes[0];
    var subcategoryTab = table_Indexes[0] + '_' + table_Indexes[1];
    var optionTab = index;

    $('#collapse' + targetTypeTab).collapse("show"); // show main type 
    $('.oblix-sub-category-navigation a[href="#' + subcategoryTab + '"]').tab('show'); // show subcategory
    $('.oblix-option-navigation a[href="#' + index + '"]').tab('show'); // show option tab


    $('#' + index + ' select.asset-selector').val(mdmId); //set select option

    //Update target asset view directly
    //Can't rely on select change() event due to accordion animation delay
    updateAssetView(mdmId);
}

var initBasketMap = function() {
    var jsonString = $('#basketJSON').val();
    basket = JSON.parse(jsonString);
    //console.log(basket);
}

var handleBasketChange = function() {
    initBasketMap();

    var currentlyVisibleAssetMDMId = getCurrentlyVisibleAssetMDMId();

    if (assetToBeRemovedMDMId != null) {
        //If asset was removed and is still displayed to user -> reset fields/buttons
        if (!inBasket(assetToBeRemovedMDMId) &&
            assetToBeRemovedMDMId == currentlyVisibleAssetMDMId) {
            updateAssetView(assetToBeRemovedMDMId);
        }
        assetToBeRemovedMDMId = null;
    } else {
        //if no asset was removed, update currently displayed asset view regardless
        if (inBasket(currentlyVisibleAssetMDMId)) {
            updateAssetView(currentlyVisibleAssetMDMId);
        }
    }
}

var handleNavigationChange = function() {
    var currentlyVisibleAssetMDMId = getCurrentlyVisibleAssetMDMId();
    updateAssetView(currentlyVisibleAssetMDMId);
}

//Method responsible for ensuring that given assets view is consistent
//with the system state
var updateAssetView = function(mdmId) {

    var index;
    var optionPanel;

    var otherName;
    var quantity;
    var description;

    if (mdmId === null) {
        //Selected "--None--"
        //No MDM ID so select visible option panel instead
        index = getCurrentlyVisibleOptionIndex();
        optionPanel = $('#' + index);

        optionPanel.find('.quantity_label').removeClass('add_assets_other_box_spacing');
        optionPanel.find('.trDescribe').addClass('hidden');

        mdmId = "null";
        otherName = "";
        quantity = "";
        description = "";

    } else {
        //Selected a valid option
        index = convertAssetMDMIdToIndex(mdmId);
        optionPanel = $('#' + index);

        var assetOtherNameLabel = $('#assetOtherNameLabel').val();
        var currentSelectOptionLabel = optionPanel.find('select.asset-selector option:selected').text();


        //Configure "Other Name" field display
        if (currentSelectOptionLabel == assetOtherNameLabel) {
            optionPanel.find('.quantity_label').addClass('add_assets_other_box_spacing');
            optionPanel.find('.trDescribe').removeClass('hidden');
        } else {
            optionPanel.find('.quantity_label').removeClass('add_assets_other_box_spacing');
            optionPanel.find('.trDescribe').addClass('hidden');
        }

        if (inBasket(mdmId)) {
            otherName = basket[mdmId].other_name;
            quantity = basket[mdmId].quantity_in_basket;
            description = basket[mdmId].other_description_info;
        }
    }

    //Set correct select option
    optionPanel.find('select.asset-selector').val(mdmId);
    optionPanel.find('.assetOtherName').val(otherName);
    optionPanel.find('.assetQuantity').val(quantity);
    optionPanel.find('.assetNotes').val(description);

    if (mdmId != null && mdmId != "null") {
        if (inBasket(mdmId)) {
            optionPanel.find('#addButton-' + index).addClass('hidden').prop('disabled', false);
            optionPanel.find('#updateButton-' + index).removeClass('hidden');
        } else {
            optionPanel.find('#addButton-' + index).removeClass('hidden').prop('disabled', false);
            optionPanel.find('#updateButton-' + index).addClass('hidden');
        }
    } else {
        optionPanel.find('#addButton-' + index).removeClass('hidden').prop('disabled', true);
        optionPanel.find('#updateButton-' + index).addClass('hidden');

    }
}

/**********************
 *
 *   HELPER METHODS
 *
 **********************/

var inBasket = function(mdmId) {
    return basket[mdmId] ? true : false;
}

var getCurrentlyVisibleOptionIndex = function() {
    var type = $('.oblix-type-container.in');
    var sub_category = type.find('.oblix-sub-category-container.active');
    var option = sub_category.find('.oblix-option-container.active');
    var currentIndex = option.attr('id');

    return currentIndex;
}

var getCurrentlyVisibleAssetMDMId = function() {
    var index = getCurrentlyVisibleOptionIndex();
    var mdmId = $('#' + index + ' select.asset-selector option:selected').val();

    if (mdmId === "null") {
        return null;
    }

    return mdmId;
}

var convertBasketAssetMDMIdToIndex = function(mdmId) {
    if (inBasket(mdmId)) {
        var item = basket[mdmId];
        var index = item.type_index + '_' + item.sub_category_index + '_' + item.option_index;
        return index;
    }
    return null;
}

var convertAssetMDMIdToIndex = function(mdmId) {
    if (inBasket(mdmId)) {
        //Speed up search and get index from the basket asset wrapper
        return convertBasketAssetMDMIdToIndex(mdmId);
    } else {
        //If mdmId not in basket - perform page search
        var index = $("option[value=" + mdmId + "]").closest(".oblix-option-container").attr('id');

        //No asset with given MDM ID was found in the page DOM
        if (typeof index == 'undefined') {
            return null;
        }

        return index;
    }
}

var blockBasket = function() {
    $('.asset_shopping_basket').block({ 
        message: 'Please wait...',
        css: {
                border: 'none',
                padding: '15px',
                backgroundColor: '#000',
                '-webkit-border-radius': '10px',
                '-moz-border-radius': '10px',
                opacity: .5,
                color: '#fff'
            }
     });
}

var unblockBasket = function() {
    $('.asset_shopping_basket').unblock();
}

var checkAddValuesForBasket = function(e) {
    console.log(e);
    
    var currentSelectionButtonId = e.id;
    var currentSelectionSplitValue = currentSelectionButtonId.split('-');
    var currentSelectedIndex = currentSelectionSplitValue[1];
    var currentContext = $('#' + currentSelectedIndex);
    
    var selectedAssetName = currentContext.find('select :selected').text();
    var selectedAssetMDMId = currentContext.find('select :selected').val();
    var selectedAssetOtherName = currentContext.find('input[name="assetOtherName"]').val();
    var selectedAssetQuantity = currentContext.find('input[name="assetQuantity"]').val();
    var selectedAssetNotes = currentContext.find('input[name="assetNotes"]').val();

    if (validateAssetParameters(selectedAssetName, selectedAssetOtherName, selectedAssetQuantity)) {
        blockBasket();
        addToBasket(selectedAssetName, selectedAssetMDMId, selectedAssetOtherName, selectedAssetQuantity, selectedAssetNotes);
    } else {
        alert(validationMessage);
    }

    return false;
}

var checkUpdateValuesForBasket = function(e) {
    console.log(e);

    var currentSelectionButtonId = e.id;
    var currentSelectionSplitValue = currentSelectionButtonId.split('-');
    var currentSelectedIndex = currentSelectionSplitValue[1];
    var currentContext = $('#' + currentSelectedIndex);
    
    var selectedAssetName = currentContext.find('select :selected').text();
    var selectedAssetMDMId = currentContext.find('select :selected').val();
    var selectedAssetOtherName = currentContext.find('input[name="assetOtherName"]').val();
    var selectedAssetQuantity = currentContext.find('input[name="assetQuantity"]').val();
    var selectedAssetNotes = currentContext.find('input[name="assetNotes"]').val();
    
    if (validateAssetParameters(selectedAssetName, selectedAssetOtherName, selectedAssetQuantity)) {
        blockBasket();
        updateInBasket(selectedAssetName, selectedAssetMDMId, selectedAssetOtherName, selectedAssetQuantity, selectedAssetNotes);
    } else {
        alert(validationMessage);
    }

    return false;
}


var validateAssetParameters = function(name, otherName, quantity) {

    var assetOtherNameLabel = $('#assetOtherNameLabel').val();
    
    if (name == assetOtherNameLabel && 
        ((otherName == "" || otherName == null || otherName.length == 0))) {

        validationMessage = 'Other asset description must be supplied.';
        return false;
    }

    if (quantity <= 0) {
        validationMessage = 'Invalid asset quantity! Quantity has to be 1 or more.';
        return false;
    }

    return true;
}



/*var checkValuesForBasket = function(e){
	console.log(e);
	var currentSelectionButtonId = e.id;
	var currentSelectionSplitValue = currentSelectionButtonId.split('-');
	var currentSelectedIndex = currentSelectionSplitValue[1];
	var currentContext = $('#'+currentSelectedIndex);
	var selectedAssetName = currentContext.find('select :selected').text();
	var selectedAssetMDMId = currentContext.find('select :selected').val();
	var selectedAssetQuantity = currentContext.find('input[name="assetQuantity"]').val();
	var selectedAssetNotes = currentContext.find('input[name="assetNotes"]').val();
      addToBasket(selectedAssetName, selectedAssetMDMId, selectedAssetQuantity, selectedAssetNotes);
	return false;
}

var toggleAssetOffering = function(indexSelector){
      console.log(indexSelector);
      var table_Indexes = indexSelector.split('_');
      var typeTab = table_Indexes[0];
      var subcategoryTab = table_Indexes[0]+ '_' +table_Indexes[1];
      var optionTab = indexSelector;
      $('.panel-collapse').collapse('hide'); // hide all then open selected tab 
      $('.nav-pills a[href="#' +indexSelector+'"]').tab('show'); // show option tab
      $('.nav-tabs a[href="#' +subcategoryTab+ '"]').tab('show');// show subcategory
      $('#collapse' + typeTab).collapse("toggle"); // toggle main type

}*/