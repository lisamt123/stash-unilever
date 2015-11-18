<!-- Created by Asmae ESSBAI For the EditProject page -->

 $(document).ready(function(){
	
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
		 $( "."+x).prop( "checked", true);
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
	function PopupValueDrivers(){           
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
                           brandLG= $('select[id*="Growthhhhh"]').val();
                           Scale1= $(".projScale1").val();
                           Scale2=  $(".projScale2").val();          
                           Innovation = $(".projInnovation").val();
                           CampaignIdea =  $(".projCampaignIdea").val();
                           blockme(); 
                           setInfoDrivers($(".projInnovation").val(),$('select[id*="Growthhhhh"]').val(),$(".projCampaignIdea").val(),$(".projScale1").val(),$(".projScale2").val());   
                           $(this).dialog("close");  
                   },                                      
                    Close: function() {
                      $( this ).dialog( "close" );
                     
                    }
                  }
                });
         });           
     } 
  
     function PopupdialogCountries(){
        
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
                        },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                      
                    }                                                     
                  }
                });
        });           
    }
     
    function PopupTimeLine(){
       
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
                          },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                      
                    }                  
                  }
                });
         });           
     }
      function PopupStages(){
       
         $(function() {
                $( "#dialogStages" ).dialog({
                  width: 600,
                  modal: true, 
                  zIndex: 9,
                  buttons: {
                     Save : function() {                            
                            var lstCompleted = '';
                            var lstProjected = '';
                            
                            $("input:checkbox[name='checkbxProjected']:checked").each(function(){
                                lstProjected = $(this).attr('value');
                                                              
                            }); 
                            $("input:checkbox[name='checkboxCompleted']:checked").each(function(){
                                lstCompleted = $(this).attr('value');                                           
                            }); 
                            console.dir('array lstCompleted:'+lstCompleted);
                            console.dir('array lstProjected :'+lstProjected);                           
                                 
                               blockme();                        
                               if(lstCompleted != ''){
								   console.dir('here');
                                   setInfoStages(lstProjected,lstCompleted,lstCompleted.replace('Completed ',''));								   
                               }else{
								   console.dir('here 2');
                                   setInfoStages(lstProjected,lstCompleted);
                               }    
                               
                            
                            $( this ).dialog( "close");   
                        },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                    }                 
                  }
             });
         });           
    }
	function PopupAgencyHub(){
        $('.addAnotherBtn').click(function(event){            
            event.preventDefault();   
            counter = counter+1;                                        
            var newRow = $('<tr><td></td><td><div class="idSplit_'+counter+'" style="display:none">{!split.id}</div></td><td></td><td><apex:inputField value="{!agencySplitInstanceJS.Percentage__c}" styleClass=" percentage pourcentageSplit_'+counter+'" style="width:30px"/> %</td><td></td></tr>');
            $('table.agencyHubList').append(newRow);           
           
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
							    console.dir(listItems);
								setAgencyHub(listItems);
								listItems = '';
								//setAgencyHubOnComplete();
								$( this ).dialog( "close");   
								
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
	