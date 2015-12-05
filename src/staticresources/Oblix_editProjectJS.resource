<!-- Created by Asmae ESSBAI For the EditProject page -->
<!-- Last modified Date : 19/11/2015 -->

 $(document).ready(function(){
	<!-- override the standard date picker -->
    $('#dialogTimeLine span.dateFormat').remove();
	$('#dialogMoreDetails span.dateFormat').remove();
	$('#datePicker').addClass('ui-dialog');
	<!-- The accordion part  -->
    $('tr.data, tr.btt').show().find('td').wrapInner('<div />');
    $('tr.data, tr.btt').find('td > div').hide();
    $('table tr.Oblix_recordTypeth').click(function(){
		//alert($(this show).find('span.recordTypeValue').text());            
		var data = $(this).next('tr');
		var btt = data.next('tr');
		var that = this;
		$('table tr.Oblix_recordTypeth').each(function(){
			if($(this).hasClass('show') && that !== this){
				$(this).next('tr').find('td > div').slideToggle('slow');
				$(this).next('tr').next('tr').find('td > div').slideToggle('slow');
				$(this).toggleClass('show');
			}
		})
		data.find('td > div').slideToggle('slow');
		btt.find('td > div').slideToggle('slow');
		$(this).toggleClass('show');
		//$('tr.data, tr.btt').find('').hide();
    });
	<!-- The JQuery tab() for all sub categories -->
	$('.Oblix_recordTypeth').click(function () {
    if(setIdCss != '[]'){
        for (var i=0; i<setIdCss.length;i++) {
            $('#'+setIdCss[i]+'_tabs').tabs();
            $('#'+setIdCss[i]+'_tabs1').tabs({
                    collapsible: true,
                    active: false
                });
            $('#'+setIdCss[i]+'_tabs2').tabs({
                    collapsible: true,
                    active: false
                });
            $('#'+setIdCss[i]+'_tabs3').tabs({
                    collapsible: true,
                    active: false
                });
            $('#'+setIdCss[i]+'_tabs4').tabs({
                    collapsible: true,
                    active: false
                });
            $('#'+setIdCss[i]+'_tabs5').tabs({
                    collapsible: true,
                    active: false
                });          
        }  
    }  
    }); 	
	if(setIdCss != '[]'){
		for (var i=0; i<setIdCss.length;i++) {
			$('#'+setIdCss[i]+'_tabs').tabs();
			$('#'+setIdCss[i]+'_tabs1').tabs({
					collapsible: true,
					active: false
				});
			$('#'+setIdCss[i]+'_tabs2').tabs({
					collapsible: true,
					active: false
				});
			$('#'+setIdCss[i]+'_tabs3').tabs({
					collapsible: true,
					active: false
				});
			$('#'+setIdCss[i]+'_tabs4').tabs({
					collapsible: true,
					active: false
				});
			$('#'+setIdCss[i]+'_tabs5').tabs({
					collapsible: true,
					active: false
				});
			$('#'+setIdCss[i]+'_tabs');
			$('#'+setIdCss[i]+'_tabs').addClass('tabs-sub');
			$('#'+setIdCss[i]+'_tabs1').addClass('ui-tabs-vertical');
			$('#'+setIdCss[i]+'_tabs2').addClass('ui-tabs-vertical');
			$('#'+setIdCss[i]+'_tabs3').addClass('ui-tabs-vertical');
			$('#'+setIdCss[i]+'_tabs4').addClass('ui-tabs-vertical');
			$('#'+setIdCss[i]+'_tabs5').addClass('ui-tabs-vertical');
			console.dir('#'+setIdCss[i]+'_tabs2');
		}
	}
	$(function () {
	   $(".checkboxCountry").change(function () {
			var selectedText = $(this).find("option:selected").text();
			var selectedValue = $(this).val();
			//alert("Selected Text: " + selectedText + " Value: " + selectedValue);
		});
    });
	   
});
	<!-- Select Regions while one of the related countries is selected  -->
	function CheckRegions(x){   
		if($('.'+x).parent().siblings('input[type=checkbox]:checked').length == 0){
			$( "."+x).prop( "checked", false);
		}else{
		    $( "."+x).prop( "checked", true);
		} 
	}
    function setWorldRegion(){
        $('#dialogCountries input[value=\'World\']').attr('checked',true);
    }
    function clearAllCountries(){
        $('#dialogCountries input[type=\'checkbox\']').prop('checked',false);
    }
    function preparePH(){
        // alert('preparePH');
        // $(".complex").find("select").addClass( "isMend" );
        $(".complex").find("span").find("select").addClass( "isMend" );
        //alert(  $(".complex").find("span").html() );
    }
    
    function setMendatory(x){
        if(x.parent().parent().parent().parent().find("span").find("select").val()==''){
            alert('Asset name can\'t be null');
            return false;
        }
        if( x.parent().parent().parent().parent().find("span").find("select").val() =='Other' && x.parent().parent().parent().parent().find(".descMend").val() =='' ){
            x.parent().parent().parent().parent().find(".error").css("display", "block");
            alert('Please give description ');
            return false;
        }else{
            return true;
        }
    }
	<!-- Added by Achref for the Value drivers Popup  -->
	function  addStyletoDependent(){
	   $('select[id*="Growthhhhh"]').addClass( "input_init xxl" );
	}
	function  addStyletoDependent2(){
	   // alert($('select[id*="Growthhhhh"]').val());
		$(this).addClass( "input_init xxl" );
	}
    <!-- Functions for the differents dialog popup -->
    function PopupdialogMoreDetails(){     
		 $(function() {
				$( "#dialogMoreDetails" ).dialog({
				  width: 600,
				  modal: true, 
				  zIndex: 9,
				  buttons: {
					 Save : function() {          
							$( this ).dialog( "close");    
							blockme();     
							setMoreDetails($(".itemDueDate").val(),$(".itemAdditionalNote").val());          
						},   
					Close : function() {                      
					  $( this ).dialog( "close" );
					}                 
				  }
				});
			  });           
    }
	
	function PopupValueDrivers(btn){           
        $(function() {
                $( "#dialogDrivers" ).dialog({
                  modal: true,
                  width: 1100,
                  zIndex: 9,
                  buttons: {
                    Save : function() { 
                           addStyletoDependent();   
                           //alert($(".projInnovation").val());  
                          // alert($('select[id*="Growthhhhh"]').val());      
                           //brandLG= $('select[id*="Growthhhhh"]').val();
                          // Scale1= $(".projScale1").val();
                           //Scale2=  $(".projScale2").val();                                  
                           //CampaignIdea =  $(".projCampaignIdea").val();
						    
						    var innovation = $('input[name="innovation"]:checked').val();								
						    console.dir(innovation);							
							console.dir($(".projBrandInnov").val());
							console.dir($(".projBrandBrand").val());
							blockme(); 									
							setInfoDrivers(innovation,$(".projBrandInnov").val(),$(".projBrandBrand").val(),$(".projCampaignIdea").val(),$(".projScale1").val(),$(".projScale2").val());     
											                          
                            $(this).dialog("close"); 
							//btn.addClass( "chekedBtn" );
							V3=1;
                   },                                      
                    Close: function() {
                      $( this ).dialog( "close" );
                     
                    }
                  }
                });
         });           
     } 
  
     function PopupdialogCountries(btn){
        
        $(function() {                   
                $( "#dialogCountries" ).dialog({
                  modal: true,
                  width: 1200,                             
                  height:450,
                  buttons: {
                     Save : function() {                            
                            var lstRegion = '';
                            var lstCountry = '';                                                   
                            $("input:checkbox[name='checkboxRegion']:checked").each(function(){
                                 lstRegion = lstRegion + $(this).attr('value')+',';
                                //alert('lstRegion: '+$(this).attr('value'));                                
                            }); 
                            $("input:checkbox[name='checkboxCountry']:checked").each(function(){
                                lstCountry = lstCountry + $(this).attr('value')+',';                          
                            });                        
                            blockme();                         
                            setInfoCountries(lstRegion.substring(0, lstRegion.length-1),lstCountry.substring(0, lstCountry.length-1));
                            //console.dir('here');                          
                            $( this ).dialog( "close");  
							//btn.addClass( "chekedBtn" );							
                        },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                      
                    }                                                     
                  }
                });
        });           
    }
     
    function PopupTimeLine(btn){
       
         $(function() {
                $( "#dialogTimeLine" ).dialog({
                  modal: true,
                  width: 1200,
                  modal: true, 
                  zIndex: 9,
                  buttons: {
                     Save : function() {                   
                             //alert($(".dateProjCD").val());    
                             blockme();      
                             setInfoTimeLine($(".dateProjSD").val(),$(".dateProjBFR").val(),$(".dateProjFR").val(),$(".dateProjCD").val(),$(".dateProjABET").val(),$(".dateProjLD").val(),$(".dateFAD").val(),$(".dateProjPREV").val(),$(".dateProjAD").val(),$(".dateProdCD").val(),$(".dateProdSP").val(),$(".ProjTimescale").val(),$(".ProjPriority").val());              
                             $(this).dialog("close"); 
							 //btn.addClass( "chekedBtn" );
                          },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                      
                    }                  
                  }
                });
         });           
     }
      function PopupStages(btn){
       
         $(function() {
                $( "#dialogStages" ).dialog({
                  width: 600,
                  modal: true, 
                  zIndex: 9,
                  buttons: {
                     Save : function() {
							
                            var lstCompleted = '';
                            var lstProjected = '';
							
							var listProjected = '';
							var listCompleted = '';
							
							listProjected = $("input:checkbox[name='checkbxProjected']:checked").map(function(){return $(this).attr('value').replace('Projected ','');}).get().join(',');
							listCompleted = $("input:checkbox[name='checkboxCompleted']:checked").map(function(){return $(this).attr('value').replace('Completed ','');}).get().join(',');
                            
                            $("input:checkbox[name='checkbxProjected']:checked").each(function(){
                                lstProjected = $(this).attr('value');
                            }); 
                            $("input:checkbox[name='checkboxCompleted']:checked").each(function(){
                                lstCompleted = $(this).attr('value');                                           
                            }); 
                            //console.dir('array lstCompleted:'+lstCompleted);
                            //console.dir('array lstProjected :'+lstProjected);                           
                                 
                               blockme();
								// SS 26/11/2015 based on today's client feedback, the user story is wrong. only projected should be taken into account, and every stage calculated individually
                               /*if(lstCompleted != ''){
								   console.dir('here');
                                   setInfoStages(lstProjected,lstCompleted,lstCompleted.replace('Completed ',''));								   
                               }else if(lstProjected != ''){
								   console.dir('here 2');
                                   setInfoStages(lstProjected,lstCompleted,lstProjected.replace('Projected ',''));
                               } else {
								   console.dir('here 3');
                                   setInfoStages(lstProjected,lstCompleted, '');
							   }*/
							   
							   
                               if(lstCompleted != ''){
									setInfoStages(listProjected,listCompleted,lstCompleted.replace('Completed ',''));
							   } else {
									setInfoStages(listProjected,listCompleted,lstProjected.replace('Projected ',''));
							   }
						    $( this ).dialog( "close");
                            //btn.addClass( "chekedBtn" );
                              
                        },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                    }                 
                  }
             });
         });           
    }
	function PopupAgencyHub(btn){

		//var countryOptions = '<select>';
		//var countries = '{!countryOptions}';
		//for(var i=0;i<countries.length;i++){
		//	countryOptions = countryOptions + '<option value="'+countries[i]+'">';
		//}
		//countryOptions = countryOptions + '</select>';
        $('.addAnotherBtn').click(function(event){            
            //event.preventDefault();   
            counter = counter+1;      			
            //var countryOption =  $('<apex:selectList value="{!split.OblixCountry__c}" multiselect="false" size="1" styleClass="countrySplit_'+counter+'"><apex:selectOptions value=""/></apex:selectList>').html();
           // console.dir(countryOptions);
           // var newRow = $('<tr><td></td><td><div class="idSplit_'+counter+'" style="display:none">{!split.id}</div></td><td>'+countryOptions+'</td><td><input class="percentage pourcentageSplit_'+counter+'" style="width:30px"/> %</td><td></td></tr>');
            //$('table.agencyHubList').append(newRow);     
           			
           
        });
        
        $(function() {
			$( "#agencyHub" ).dialog({
			  width: 800,
			  modal: true, 
			  zIndex: 9,
			  buttons: {
				 Save : function() {                            
						var sum = 0;
						var listItems = '';
						var block = true;
						$(".percentage").each(function(){
							sum = sum + Number($(this).val());
							//alert(sum);
					   });      
					   //alert( $(".countrySplit_1").val()); 
					   //alert( $(".dateProdCD").val());                
					   if(sum != 100){
							alert('the values must be equal to 100');
						}else{
							for(var indice = 1;indice<counter+1;indice++){                               
							   // alert($(".idSplit_"+indice).text());
								//alert($(".pourcentageSplit_"+indice).val());
								var id = $(".idSplit_"+indice).text();
								var country = $(".countrySplit_"+indice).val();
								var percentage = $(".pourcentageSplit_"+indice).val();  
								if($(".idSplit_"+indice).text().length == 0) id = ' '; 
								if($(".countrySplit_"+indice).val().length == 0) country = ' ';
								if($(".pourcentageSplit_"+indice).val().length == 0) percentage = 0;    
								if(country == ' ' && (percentage != 0 || $(".pourcentageSplit_"+indice).val() != 0)){
									alert('Country is required');
									block = false;
								}
																											  
								listItems = listItems + id+'_'+country+'_'+percentage+',';
							   
							}       
							if(block){
								//alert(listItems);  
								blockme();  
							    //console.dir(listItems);
								setAgencyHub(listItems);
								listItems = '';
								//setAgencyHubOnComplete();
								$( this ).dialog( "close");
							    // btn.addClass( "chekedBtn" );
								
							}
						}
					},                                       
				Close : function() {
				  $( this ).dialog( "close" );
				}                 
			  }
			});
		  });           
    }
	// The set as global confirmation popup 
	function confirmSetAsGlobal(){
        $(function() {
            $( "#dialog-confirm" ).dialog({
                resizable: false,
                modal: true,
                buttons: {
                    "Set as Global": function() {
                        blockme();
                        setAsGlobal();
                        $( this ).dialog( "close" );
						$( "#dialogCountries" ).dialog( "close" );
                    },
                    Cancel: function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        });
    }
	// the Add/Update mendatory field verification 
     function setMendatory(x){
            if(x.parent().parent().parent().parent().find("span").find("select").val()== ''){
				alert('Asset name can\'t be null');
			 return false;
		 }
		if( x.parent().parent().parent().parent().find("span").find("select").val() == 'Other' && x.parent().parent().parent().parent().find(".descMend").val() =='' ){
			x.parent().parent().parent().parent().find(".error").css("display", "block");
            alert('Please give description ');       
            return false;
        }else
        return true;
        
        }
		function showhideDetail(x){ 
			if( x.parent().parent().parent().parent().parent().parent().find("span").find("select").val() == 'Other'){
				x.parent().parent().parent().parent().parent().parent().find(".trDescribe").removeAttr("style");				
			}else{
				x.parent().parent().parent().parent().parent().parent().find(".trDescribe").css("display","none");			
			}
			return false;
        }
		
		// The Edit/delete  mode 
		 $(function (){
				if(window.location.search.indexOf('&') > -1){
					if(window.location.search.split('&')[1].split('=')[0] === 'assetId'){
						openAsset()
					}                      
				}
			});
			  var removeAsset = function(assetId){
				blockme();
				Oblix_Ctrl07ProjectEdit_CC.removeAsset(assetId, function (data, event){
				  if(event.status){
					refreshAsset();
				  }
				});
			  };

			  var getAssetDetails = function (assetId){
				var deferred = $.Deferred();
				Oblix_Ctrl07ProjectEdit_CC.getAssetDetails(assetId, function (assetDetails, event) {
				  deferred.resolve({data: assetDetails, status: event});
				});
				return deferred.promise();
			  }

			  var updateAsset = function (btn){
				blockme();
				var button = $(btn);
				var assetId = button.attr('data-asset-id');
				var inputDate = $('#dialogMoreDetails table tr:first()').next().find('input').val();
				var date = inputDate.split('-').reverse().toString().replace(new RegExp(',','g'), '-');
				var details = {
				  quantity: button.siblings('input[type="text"]').val(),
				  location: button.closest('tbody').children().first().next().find('input').val(),
				  asset_Picklist: button.closest('tbody').children().first().find('input').val()//,
				  //actual_Delivery_Date: date,
				  //additional_Description: $('#dialogMoreDetails table tr:last()').find('textarea').val()
				}

				Oblix_Ctrl07ProjectEdit_CC.UpdateProjectAction(assetId, details, function (data, event){
				  button.addClass('hide_button');
				  button.siblings('input[type="submit"]').removeClass('hide_button');
				  refreshAsset();
				  //$('#dialogMoreDetails table tr:first()').next().find('input').val('');
				  //$('#dialogMoreDetails table tr:last()').find('textarea').val('');
				});
			  }

			  var openAsset = function (){
				var assetId = window.location.search.split('&')[1].split('=')[1];
				var assetDetails = getAssetDetails(assetId);
				assetDetails.then(function (data){
					if(data.status.status){
						var assetName = data.data.assetTitle;
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
				  Object.keys(allAbreviation).forEach(function (key){
					var currentAbraviation = allAbreviation[key];
					if(currentAbraviation === selectedAbreviation[0] + '-' + selectedAbreviation[1]){
					  options = key.split('_');
					}
				  })
					firstOption = options[0];
				  secondOption = options[1];				  
				  $('.Oblix_recordType').find('.Oblix_recordTypeth').each(function (index, el) {
					if($(el).text().search(firstOption) !== -1 ){
					  firstElement = $(el);
					  var secondSearchArray = firstElement.first().next().find('span > div[id*="_tabs"]').children('ul');
					  secondSearchArray.find('a').each(function (index, el) {
						  if($(el).text().search(secondOption) !== -1){
							secondElement = $(el);
							var curentIndex = index + 1;
							var selector1 = 'div[id*="_tabs-' + curentIndex + '"]';
							var selector2 = 'a[href*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
							thirdElement = secondSearchArray.siblings(selector1).find('ul').find(selector2);
							selectorDetailPanel = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
						  }
					  });
					}
				  });
				  var detailPanel = thirdElement.closest('ul').siblings(selectorDetailPanel).find('tbody');
				  
					  detailPanel.find('tr').first().find('span select').val(data.data.assetName);
					  detailPanel.find('tr').first().next().find('input').val(data.data.location);
					  detailPanel.find('tr').first().next().next().find('input[type="text"]').val(data.data.quantity);
					  /*$('#dialogMoreDetails table tr:first()').next().find('input').val(new Date(data.data.actualDeliveryDate).toLocaleString().split(',')[0].replace('.', '-').replace('.', '-'));
					  $('#dialogMoreDetails table tr:last()').find('textarea').val(data.data.additionalDescription);*/
					
				  
				  
				  if(firstElement && !firstElement.hasClass('show')) firstElement.trigger('click');
				  if(secondElement && secondElement.find('a').attr('tabindex') !== '0') secondElement.trigger('click');
				  if(thirdElement && !thirdElement.parent().hasClass('ui-state-active')) {
					detailPanel.find('tr').first().next().next().find('input[type="submit"]').each(function(index, el) {
					  var button = $(el);
					  if(button.val() === 'Update'){
						button.removeClass('hide_button')
						.attr('data-asset-id', assetId)
					  } else {
						button.addClass('hide_button');
					  }
					});
					thirdElement.trigger('click');

				  }
					}
				}, function (err){
				console.log(err);
			  });
				  
			  }

			  var editAsset = function (el, assetId){
				//debugger;
				  var assetDetails = getAssetDetails(assetId);
				  var assetName = $(el).closest('.Oblix_card_elmt').find('span').text();
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
				  Object.keys(allAbreviation).forEach(function (key){
					var currentAbraviation = allAbreviation[key];
					//debugger;
					if(currentAbraviation === selectedAbreviation[0] + '-' + selectedAbreviation[1]){
						//debugger;
					  options = key.split('_');
					} /*else if(currentAbraviation === selectedAbreviation[1]){
					  secondOption = key;
					}*/
				  })

				  firstOption = options[0];
				  secondOption = options[1];
				  
				  $('.Oblix_recordType').find('.Oblix_recordTypeth').each(function (index, el) {
					if($(el).text().search(firstOption) !== -1 ){
					  firstElement = $(el);
					  var secondSearchArray = firstElement.first().next().find('span > div[id*="_tabs"]').children('ul');
					  secondSearchArray.find('a').each(function (index, el) {
						  if($(el).text().search(secondOption) !== -1){
							secondElement = $(el);
							var curentIndex = index + 1;
							var selector1 = 'div[id*="_tabs-' + curentIndex + '"]';
							var selector2 = 'a[href*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
							thirdElement = secondSearchArray.siblings(selector1).find('ul').find(selector2);
							selectorDetailPanel = 'div[id*="_tabs-' + curentIndex + thirdOption.replace(/^0+/, '') + '"]';
						  }
					  });
					}
				  });
				  var detailPanel = thirdElement.closest('ul').siblings(selectorDetailPanel).find('tbody');
				  assetDetails.then(function (data){
					if(data.status.status){
					  detailPanel.find('tr').first().find('span select').val(data.data.assetName);
					  detailPanel.find('tr').first().next().find('input').val(data.data.location);
					  detailPanel.find('tr').first().next().next().find('input[type="text"]').val(data.data.quantity);
					  /*$('#dialogMoreDetails table tr:first()').next().find('input').val(new Date(data.data.actualDeliveryDate).toLocaleString().split(',')[0].replace('.', '-').replace('.', '-'));
					  $('#dialogMoreDetails table tr:last()').find('textarea').val(data.data.additionalDescription);*/
					}
				  }, function (err){
					console.log(err);
				  });
				  
				  if(firstElement && !firstElement.hasClass('show')) firstElement.trigger('click');
				  if(secondElement && secondElement.find('a').attr('tabindex') !== '0') secondElement.trigger('click');
				  if(thirdElement && !thirdElement.parent().hasClass('ui-state-active')) {
					thirdElement.trigger('click');
				  }
				  detailPanel.find('tr').first().next().next().find('input[type="submit"]').each(function(index, el) {
					  var button = $(el);
					  if(button.val() === 'Update'){
						button.removeClass('hide_button')
						.attr('data-asset-id', assetId)
					  } else {
						button.addClass('hide_button');
					  }
					});
			  }
			  var getAbreviationForCardAssets = function (){
				Oblix_Ctrl07ProjectEdit_CC.getAbreViationByRTBySubCatgForCardAssets(function (data, event){
				  if(event.status){
					sessionStorage.setItem('assestAbreviations', JSON.stringify(data));
				  }
				});
			  }
			  getAbreviationForCardAssets();