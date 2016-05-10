  function openLookup(baseURL, width, modified, searchParam){
    var originalbaseURL = baseURL;
    var originalwidth = width;
    var originalmodified = modified;
    var originalsearchParam = searchParam;
    var lookupType = baseURL.substr(baseURL.length-3, 3);
    var asset = 'Asset';
    var urllength = 2;
    if (modified == '1') baseURL = baseURL + searchParam;
    var isCustomLookup = false;
    if(lookupType == "a6N"){// Following "001" is the lookup type for Account object so change this as per your standard or custom object
      var urlArr = baseURL.split("&");
      var txtId = '';
      var spliter= '=';
      if(urlArr.length > urllength) {
        urlArr = urlArr[1].split(spliter);
        txtId = urlArr[1];
      }
        baseURL ='{!$Page.Oblix_VF03CustomAssetLookup}'+"?txt="+ txtId;// "/apex/Oblix_VF03CustomAssetLookup?txt=" 
      var assetType = '{!rtName}';// Following is the url of Custom Lookup page. You need to change that accordingly
      var categoryType = '{!asset.Sub_Category__c}'; 
      if( assetType != null && assetType != ''){ baseURL += "&assetType="+assetType; }
      if(categoryType != null && categoryType != ''){ baseURL += "&subCategory="+categoryType; }
      baseURL = baseURL + "&frm=" + escapeUTF("{!$Component.myForm}");// Following is the id of apex:form control "myForm". You need to change that accordingly
      if (modified == '1') { baseURL = baseURL + "&lksearch=" + searchParam;}
      if(txtId.indexOf(asset) > -1 ){isCustomLookup = true;}// Following is the ID of inputField that is the lookup to be customized as custom lookup
    }
    if(isCustomLookup == true){openPopup(baseURL, "lookup", 350, 480, "width="+width+",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true);}
    else {
      if (modified == '1') originalbaseURL = originalbaseURL + originalsearchParam;
      openPopup(originalbaseURL, "lookup", 350, 480, "width="+originalwidth+",height=480,toolbar=yes,status=yes,directories=no,menubar=yes,resizable=yes,scrollable=no", true);
    } 
  }