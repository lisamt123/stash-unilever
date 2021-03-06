var uploadHelper = function() {
          //workaround for issue with Sarissa on IE (Sarrisa preventd sending blob)
          var NATIVEXHR;
          if (window.Sarissa && Sarissa.originalXMLHttpRequest) {
              NATIVEXHR = Sarissa.originalXMLHttpRequest;
          } else {
              NATIVEXHR = XMLHttpRequest;
          }

          //Boundary for the multipart-formdata reqyest
          var boundary = "blob987645nhf98q365hfq0398547nhf3487" + (new Date()).getTime();

          var _getFileName = function(fileField) {
              if (fileField && fileField.files.length == 1 && fileField.files[0].name) {
                  return fileField.files[0].name;
              } else {
                  return false;
              }
          };

          var _getFileContentType = function(fileField) {
              if (fileField && fileField.files.length == 1 && fileField.files[0].type) {
                  return fileField.files[0].type;
              } else {
                  return 'application/octet-stream';
              }
          };
          var _getChatterJSONData = function(subjectId, options) {
              var sfData = {
                  "capabilities": {
                      "content": {
                          "description": options.contentDescription,
                          "title": options.contentTitle
                      }
                  },
                  "feedElementType": "FeedItem",
                  "subjectId": subjectId
              };
              if (!_isEmpty(options.messageText)) {
                  sfData.body = {
                      "messageSegments": [{
                          "type": "Text",
                          "text": options.messageText
                      }]
                  };
              }
              return sfData;
          };

          var _isEmpty = function(val) {
              return val === null || val === undefined || val === '';
          };

          var startMultipartFormData = function(data) {
              data.push('--' + boundary);
          };

          var endMultipartFormData = function(data) {
              data.push('--' + boundary + '--');
          };

          var addMultipartMetaData = function(data, name, fileName, contentType) {
              if (_isEmpty(fileName)) {
                  data.push('Content-Disposition: form-data; name="' + name + '"');
                  data.push('Content-Type: ' + contentType);
                  data.push('');
              } else {
                  data.push('Content-Disposition: form-data; name="' + name + '"; filename="' + fileName + '"');
                  data.push('Content-Type: ' + contentType);
                  data.push('');
                  data.push('');//it is not mistake. we need extra \r\n before file content when we merge blob
              }
          };

          var _getFileReader = function(options, successHandler) {
              var reader = new FileReader();
              reader.addEventListener("load", function() {
                  successHandler();
              });
              reader.addEventListener("error", function(e) {

                  switch (e.target.error.code) {
                      case e.target.error.NOT_FOUND_ERR:
                          options.errorHandler('Failed while uploading file.');
                          break;
                      case e.target.error.NOT_READABLE_ERR:
                          options.errorHandler('Failed while uploading file.');
                          break;
                      case e.target.error.ABORT_ERR:
                          break;
                      default:
                          options.errorHandler('Failed while uploading file');
                  }
              });

              reader.addEventListener("abort", function(e) {
                  options.errorHandler('Failed while uploading file');
              });

              return reader;
          };

          var _getXHR = function(options) {
              var XHR = new NATIVEXHR();
              XHR.addEventListener('load', function(event) {
                  if (event && event.target) {
                      if (event.target.status !== 201) {
                          options.errorHandler('Failed while uploading file');
                          return;
                      }
                      var response;
                      try {
                          response = JSON.parse(event.target.response);
                      } catch (e) {
                          options.errorHandler('Failed while uploading file');
                          return;
                      }
                      options.successHandler(response);
                  } else {
                      options.errorHandler('Failed while uploading file');
                      return;
                  }
              });

              // We define what will happen in case of error
              XHR.addEventListener('error', function(event) {
                  options.errorHandler('Failed while uploading file');
              });

              XHR.open('POST', '/services/data/v32.0/chatter/feed-elements');

              //add headers
              XHR.setRequestHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
              XHR.setRequestHeader('Authorization', 'Bearer ' + __sfdcSessionId);
              XHR.setRequestHeader('Accept', 'application/json');

              //upload porgress bar
              if (XHR.upload && options.uploadHanlder) {
                if (options.uploadHanlder.progress) {
                  XHR.upload.addEventListener("progress", function(a) { options.uploadHanlder.progress(a.loaded, a.total);}, false);
                }
                if (options.uploadHanlder.load) {
                  XHR.upload.addEventListener("load", function(a) { options.uploadHanlder.load(a);}, false);
                }
              } 
              return XHR;
          };

          var _buildAndSendRequest = function(fileArrayBuffer, subjectId, options) {
              var sfData = _getChatterJSONData(subjectId, options);
              // we'll store our body request as a string.
              var data1 = [];
              var data2 = [];

              startMultipartFormData(data1);

              //chatter data
              addMultipartMetaData(data1, 'json', null, 'application/json; charset=UTF-8');
              data1.push(JSON.stringify(sfData, null, ' '));
              data1.push('');

              //file data
              startMultipartFormData(data1);
              addMultipartMetaData(data1, 'feedElementFileUpload', options.fileName, options.contentType);
              data2.push('');
              endMultipartFormData(data2);

              //build blob data
              var blob = new Blob([data1.join('\r\n'), fileArrayBuffer, data2.join('\r\n')]);
              var xhr = _getXHR(options);
              xhr.send(blob);
          };

          var sendFile = function(fileFieldId, subjectId, options) {
              var contentType, fileField;
              options = options || {};
              options.fielField = fileField;
              options.errorHandler = options.errorHandler || function(msg) {
                  if (window.console && window.console.error) {
                      console.error(msg);
                  }
              };
              //check if file field Id has been passed
              if (!fileFieldId) {
                  options.errorHandler('Missing file field Id');
                  return false;
              }

              //check if field exists
              fileField = document.getElementById(fileFieldId);
              if (!fileField) {
                  options.errorHandler('Given file field does not exist');
                  return false;
              }

              if (!subjectId || typeof subjectId !== 'string' || subjectId.length !== 18) {
                  options.errorHandler('Invalid Salesforce object Id. It has to be 18 characters long string');
                  return false;
              }
              //check if file has been selected
              options.fileName = _getFileName(fileField);
              if (options.fileName === false) {
                  options.errorHandler('Please choose a file');
                  return;
              }
              options.contentType = _getFileContentType(fileField);
              options.contentTitle = options.contentTitle || options.fileName;
              options.contentDescription = options.contentDescription || '';
              //readFile
              var reader = _getFileReader(options, function() {
                  _buildAndSendRequest(reader.result, subjectId, options);
              });

              reader.readAsArrayBuffer(fileField.files[0]);
          };

          return {
              sendFile: sendFile
          };
      };

      var upload = new uploadHelper();  

      var saveInProgress = false;

    function saveForm(){
      if(saveInProgress){
        return false;
      }else{
        saveInProgress = true;
      }

      saveAsset();
    };

    function validation(){
      var errors = [];
      var subFunctionValue = jQuery('[id$="fileSubFunction"]')[0].value;
      var fileTypeValue = jQuery('[id$="fileAssetType"]')[0].value;
      var fileStatusValue = jQuery('[id$="fileStatus"]').val();
      var fileMediatypeValue = jQuery('[id$="fileMediaChannel"]')[0].value;
      var fileCountryValue = jQuery('[id$="fileCountry"]')[0].value;

      var input = document.getElementById('file-input');
      var filesToUpload = input.files;

      if( subFunctionValue === ''){
        errors.push('Sub Function cannot be empty.')
      }else{
        if(subFunctionValue === 'Brand Development'){
          if(fileTypeValue === ''){
            errors.push('Type cannot be empty.')
          }else{
            if(fileStatusValue === ''){
              errors.push('Status cannot be empty.')
            }

            if(fileTypeValue === 'Creative Work'){
              if(fileMediatypeValue === ''){
                errors.push('Media Type cannot be empty.')
              }

              if(fileMediatypeValue === 'BET Presentation'){
                errors.push('Media Type cannot be BET Presentation.')
              }

              if(fileCountryValue === ''){
                errors.push('Country cannot be empty.')
              }
            }else{
              jQuery('[id$="fileCountry"]')[0].value = '';
              jQuery('[id$="fileMediaChannel"]')[0].value = '';
            }            
          }
        }else{
          jQuery('[id$="fileAssetType"]')[0].value = '';

          if(fileMediatypeValue === ''){
            errors.push('Media Type cannot be empty.')
          }

          if(fileMediatypeValue === 'BET Presentation'){
            errors.push('Media Type cannot be BET Presentation.')
          }

          if(fileCountryValue === ''){
            errors.push('Country cannot be empty.')
          }
        }
      }

      if(filesToUpload.length == 0){
        errors.push('File cannot be empty.')
      }

      return errors;
    };

    function saveAsset(){
      jQuery('#ballsWaveG').show();
      jQuery('.process-status').html('Uploading File...');
      var validationResult = validation();

      if(validationResult.length > 0){
        jQuery('#ballsWaveG').hide();
        var errors = '<p style="color: red;">Errors on the form: <br />';
        for(var i=0;i<validationResult.length;i++){
          errors += validationResult[i] +'<br />';
        }
        errors += '</p>';
        jQuery('.form-errors').html(errors);
        jQuery('.form-errors').show();
        jQuery('.process-status').html('');
        saveInProgress = false;
        return false;
      }else{
        jQuery('.form-errors').html('');
        jQuery('.form-errors').hide();

        uploadFile();
      }
    };

    function uploadFile(){
        jQuery('#ballsWaveG').show();
        jQuery('.process-status').html('Uploading File...');
        var parentId = jQuery('[id$="parentId"]')[0].value;
        options = {
            errorHandler: function(msg) {
                saveInProgress = false;
                jQuery('#ballsWaveG').hide();
                jQuery('.form-errors').html(msg);
                jQuery('.form-errors').show();
                jQuery('.process-status').html('');
            },
            successHandler: function(result) {
                methodOneInJavascript(result.id);
                
            },
            uploadHanlder: {
                progress: function(loaded, total) {
                    var value = (loaded/total*100).toPrecision(4)
                    jQuery('.process-status').html('Uploading File... ' + value + '%');
                },
                load: function(evt) {
                    jQuery('.process-status').html('Saving data');
                }
            },
            //messageText: 'messageText', //message to display above uploaded file
            //contentTitle: 'title for the uploaded file', //it is set by default to filename'
            contentDescription: jQuery('[id$="fileName"]').val()
        };
        upload.sendFile('file-input', parentId,  options);
    }

    function prepareForm(){
      jQuery('[id$="fileMediaChannel"] option[value="BET Presentation"]').remove();

      if(jQuery('[id$="fileSubFunction"]')[0].value === 'Brand Development'){
        jQuery('[id$="fileAssetTypeArea"]').removeClass('elementHidden');
        jQuery('[id$="fileStatusArea"]').removeClass('elementHidden');
        if(jQuery('[id$="fileAssetType"]')[0].value === 'Creative Work'){
          jQuery('[id$="fileMediaChannelArea"').removeClass('elementHidden');
          jQuery('[id$="fileCountryArea"').removeClass('elementHidden');
        }
      }else if(jQuery('[id$="fileSubFunction"]')[0].value === 'Brand Building'){
        jQuery('[id$="fileMediaChannelArea"]').removeClass('elementHidden');
        jQuery('[id$="fileCountryArea"]').removeClass('elementHidden');
      }
    }

    function fileAssetTypeAction(value){
      jQuery('[id$="fileStatusArea"').removeClass('elementHidden');
      if(value === "Brand Experience Presentation"){
        jQuery('[id$="fileMediaChannelArea"]').addClass('elementHidden');
        jQuery('[id$="fileCountryArea"]').addClass('elementHidden');
      }else if(value === "Creative Work"){
        jQuery('[id$="fileMediaChannelArea"]').removeClass('elementHidden');
        jQuery('[id$="fileCountryArea"]').removeClass('elementHidden');
      }else{
        jQuery('[id$="fileMediaChannelArea"]').addClass('elementHidden');
        jQuery('[id$="fileCountryArea"]').addClass('elementHidden');
      }
    }