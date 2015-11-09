var numberOfFilesInUploadQueue = 0;
   
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

          var _getFileName = function(fileField, idx) {
              if (fileField &&  fileField.files[idx].name) {
                  return fileField.files[idx].name;
              } else {
                  return false;
              }
          };

          var _getFileContentType = function(fileField, idx) {
              if (fileField && fileField.files[idx].type) {
                  return fileField.files[idx].type;
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

          var sendFile = function(fileFieldId, subjectId, options, idx) {
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
              options.fileName = _getFileName(fileField, idx);
              if (options.fileName === false) {
                  options.errorHandler('Please choose a file');
                  return;
              }
              options.contentType = _getFileContentType(fileField, idx);
              options.contentTitle = options.contentTitle || options.fileName;
              options.contentDescription = options.contentDescription || '';
              //readFile
              var reader = _getFileReader(options, function() {
                  _buildAndSendRequest(reader.result, subjectId, options);
              });

              reader.readAsArrayBuffer(fileField.files[idx]);
          };

          return {
              sendFile: sendFile
          };
      };

      var upload = new uploadHelper(); 
  // UTILS

  // MODEL

    function getTableHeader(){
      return '<tr><th class="multiFileUploadTableHeaderStyle" style="width:120px;">' +
          '  Upload status' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="">' +
          '  File Name' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="">' +
          '  Asset Name' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="width:100px;">' +
          '  Type' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="">' +
          '  Media Type' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="">' +
          '  Country' +
          '</th>' +
          '<th class="multiFileUploadTableHeaderStyle" style="">' +
          '  Status' +
          '</th></tr>';
    }

    function getTableRow(){
      return '<tr class="fileRow" id="fileRow-{1}" > '+
            '  <td class="uploadStatusCell"></td> ' +
            '  <td>{0}</td> ' +
            '  <td><input id="selFile-{1}" class="inAssetName" type="value" value="{2}"></input></td> ' +
            '  <td>Creative Work</td> ' +
            '  <td> ' +
            getMediaTypePicklist() +                    
            '  </td> ' +
            '  <td> ' +
            getCountriesPicklist() +                   
            '  </td> ' +
            '  <td> ' +
            getStatusPicklist() +                  
            '  </td> ' +
            '</tr>';
    }

    function getMediaTypePicklist(){
      var retVal = '<select id="plMediaTypes-{1}">';

      for (var i = 0; i < liMediaType.length; i++) {
        retVal += '<option value="' + liMediaType[i] +'">' + liMediaType[i] +'</option> ';
      }

      retVal += '</select>';
      return retVal;
    }

    function getCountriesPicklist(){
      var retVal = '<select id="plCountries-{1}" multiple="multiple" class="plCountries">';

      for (var i = 0; i < liCountries.length; i++) {
        retVal += '<option value="' + liCountries[i] +'">' + liCountries[i] +'</option> ';
      }

      retVal += '</select>';
      return retVal;
    }

    function getStatusPicklist(){
      var retVal = '<select id="plStatus-{1}">';

      for (var i = 0; i < liStatus.length; i++) {
		if(defStatus == liStatus[i]) {
			retVal += '<option value="' + liStatus[i] +'" selected>' + liStatus[i] +'</option> ';
		} else {
			retVal += '<option value="' + liStatus[i] +'">' + liStatus[i] +'</option> ';
		}
      }

      retVal += '</select>';
      return retVal;
    }
	
	//added
	
	function uploadSingleFile(idx){
        var parentId = groupId;
        options = {
            errorHandler: function(msg) {
                saveInProgress = false;
            },
            successHandler: function(result) {

                console.log('File uploaded ' + idx);

                var assetName = document.getElementById('selFile-'+idx).value;
                var es = document.getElementById('plStatus-'+idx);
                var status = es.options[es.selectedIndex].text;

                var emt = document.getElementById('plMediaTypes-'+idx);
                var mediaType = emt.options[emt.selectedIndex].text;

                var emt = document.getElementById('plMediaTypes-'+idx);
                var mediaType = emt.options[emt.selectedIndex].text;

                var fld = document.getElementById('plCountries-'+idx);
                var country = '';
                for (var i = 0; i < fld.options.length; i++) {
                  if (fld.options[i].selected) {
                    country += fld.options[i].value + ';'
                  }
                }

                console.log(' asset details : ' + assetName + ', ' + status + ', ' + mediaType + ', ' + country + ', ' + betId);

                var cb = function() {
                  numberOfFilesInUploadQueue--;
                  if (numberOfFilesInUploadQueue==0) {
                    window.top.postMessage(
                      {
                        action: 'saveAssets'
                      },
                      document.location.protocol + '//' + document.domain
                      );
                    }
                };
                labelFile(result.id,assetName,mediaType,country,status,betId,idx,cb);
            },
            uploadHanlder: {
                progress: function(loaded, total) {
                    var value = (loaded/total*100).toPrecision(4);
                    jQuery(".uploadStatusCell:eq("+idx +")").html('Uploading File... ' + value + '%');
                },
                load: function(evt) {
                    jQuery(".uploadStatusCell:eq("+idx +")").html('Saving data');
                }
            },
            contentDescription: jQuery("#selFile-"+ idx).val()
        };
        upload.sendFile('multiplefiles', parentId,  options, idx);
    }

    function filesSelected(){
      var sTableHTML = '' + getTableHeader();
      var filelist = document.getElementById("multiplefiles").files || [];
      for (var i = 0; i < filelist.length; i++) {
        var line = getTableRow().replace(/\{0\}/g,filelist[i].name).replace(/\{1\}/g,i).replace(/\{2\}/g,filelist[i].name);
        sTableHTML += line;
      }
      jQuery("#inputFiles").html(sTableHTML);
    }
  
    function loadFiles(){
      var filelist = document.getElementById("multiplefiles").files || [];
      if (validateInput()){
        numberOfFilesInUploadQueue = filelist.length;
        for (var i = 0; i < filelist.length; i++) {
            uploadSingleFile(i);
        }
      }
    }
	
	
	function validateInput(){
      var retVal = true;
      var errors = [];
      var errorHTML = '';

      jQuery('.form-errors').hide();
      jQuery('.error-frame').removeClass('error-frame');
      var filelist = document.getElementById("multiplefiles").files || [];
      if (filelist.length == 0){
        errors[NO_FILE_SELECTED] = NO_FILE_SELECTED;
        retVal = false;
      }

      jQuery('.inAssetName').each(function(idx, elem) {
        if(!jQuery(elem).val()){
          errors[NO_ASSET_NAME] = NO_ASSET_NAME;
          jQuery(elem).addClass('error-frame');
          retVal = false;
        }
      });

      jQuery('.plCountries').each(function(idx, elem) {
        if(!jQuery(elem).val()){
          errors[NO_COUNTRY_SELECTED] = NO_COUNTRY_SELECTED;
          jQuery(elem).addClass('error-frame');
          retVal = false;
        }
      });

      for (key in errors){
        if(key == NO_COUNTRY_SELECTED || key == NO_ASSET_NAME || key == NO_FILE_SELECTED) {
          errorHTML += errors[key] + '<br>';
        }
      }

      if (!retVal){
        var errorTemplate = [
        '<div class="message errorM3" role="alert">',
          '<table border="0" cellpadding="0" cellspacing="0" class="messageTable" style="padding:0px;margin:0px;">',
            '<tbody><tr valign="top">',
                '<td><img alt="ERROR" class="msgIcon" src="/s.gif" title="ERROR"></td>',
                '<td class="messageCell"><div class="messageText"><span style="color:#cc0000"><h4>Error:</h4></span>',
                errorHTML,
                '</div></td>',
            '</tr></tbody>',
          '</table>',
        '</div>'];
        jQuery('.form-errors').html(errorTemplate.join(''));
        jQuery('.form-errors').show();
      }

      return retVal;
    }
	
	function labelFileCallback(event,result,index,cb){
      if (event.status) {
        if(result == null) {
          jQuery(".uploadStatusCell:eq("+index+")").html(uploadOkInfo);
            if (cb) {
              cb();
            }
        } else {
          jQuery(".uploadStatusCell:eq("+index+")").html(uploadFailedInfo);
          jQuery('.form-errors').html(result);
          jQuery('.form-errors').show();
        }
      } else {
        jQuery(".uploadStatusCell:eq("+index+")").html(uploadFailedInfo);
        jQuery('.form-errors').html(result);
        jQuery('.form-errors').show();
      }
    }
 