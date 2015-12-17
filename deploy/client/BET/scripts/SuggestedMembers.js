		function colapseExternalGroup(){
            var $ = jQuery.noConflict();
            var parentElement = $('div[id="groupExternal"]');
            if(parentElement){
                parentElement.find('div[id^="euserId_"]').hide();
            }
            var expandIconId = 'groupExternal_Expand';
            var colapseIconId = 'groupExternal_Colapse';
            var expandIconElement = $('div[id='+expandIconId+']');
            var colapseIconElement = $('div[id='+colapseIconId+']');
            if(expandIconElement){
                expandIconElement.show();
            }
            if(colapseIconElement){
                colapseIconElement.hide();
            }
        }

        function expandExternalGroup(){
            var $ = jQuery.noConflict();
            var parentElement = $('div[id="groupExternal"]');
            if(parentElement){
                parentElement.find('div[id^="euserId_"]').show();
            }
            var expandIconId = 'groupExternal_Expand';
            var colapseIconId = 'groupExternal_Colapse';
            var expandIconElement = $('div[id='+expandIconId+']');
            var colapseIconElement = $('div[id='+colapseIconId+']');
            if(expandIconElement){
                expandIconElement.hide();
            }
            if(colapseIconElement){
                colapseIconElement.show();
            }
        }



/************************************************************
	Purpose: Select or unselect checkboxes unde Add Members modal
*************************************************************/

function selectOrUnselect(obj){
	if(obj){
		if(obj.attr('checked')){
			obj.attr('checked',true); //obj.attr('checked',false);
		}else{
			obj.attr('checked',false); //obj.attr('checked',true);
		}
	}
}

function selectOrUnselectModal(obj){
	if(obj){
		if(obj.attr('checked')){
			obj.attr('checked',false); //obj.attr('checked',false);
		}else{
			obj.attr('checked',true); //obj.attr('checked',true);
		}
	}
}

/************************************************************
	Purpose: Unblock UI
*************************************************************/    
function resizeModalAfrerSearch(){
	unlockUI();
}

/************************************************************
	Purpose: Method used when searching new Members
*************************************************************/    
function searchUsersBtn(){
	var $ = jQuery.noConflict();
	$.blockUI({ css: { 
	border: 'none', 
	padding: '15px', 
	backgroundColor: '#000', 
	'-webkit-border-radius': '10px', 
	'-moz-border-radius': '10px', 
	opacity: .5, 
	color: '#fff'
	},
	message: 'Searching...' });
	searchUsers();
}
/************************************************************
	Purpose: Remove all elements from search modal 
*************************************************************/ 
function clearSearchForm(){
	var $ = jQuery.noConflict();
	if($('.searchMemberItem')){
		if($('.searchMemberItem').children()){
			$('.searchMemberItem').children().remove();
		}
	}
	unlockUI();
	clearExpandColapseAfterRender();
}

function clearSearchFormAfterSumbit(){
	unlockUI();
	clearExpandColapseAfterRender();
}


/************************************************************
	Purpose: 
*************************************************************/ 
function addOtherMembers(){
}

/************************************************************
	Purpose: Gather all selected users which should be added to Team Members
			 and passing this information to backend
*************************************************************/ 
function addAllNewMembers(){ 
	var $ = jQuery.noConflict();
	var searchMembers = $('.searchMemberItem');
	if(searchMembers){
		var selectedMembers = searchMembers.find('[id^="userIdCheckbox_"]');
		var selectedUsers = '';
		if(selectedMembers){
			selectedMembers.each(function () {
				if($(this).attr('checked')){
					selectedUsers += $(this).val()+','; 
				}
				
			});
		}
		
		if(selectedUsers.length>0){
			selectedUsers = selectedUsers.substring(0, selectedUsers.length-1);
		}
		addNewMembers(selectedUsers);
		lockUI();
		//clearSearchByNameField();
	}
}

/************************************************************
	Purpose: Clear search text in adding new memebers modal
*************************************************************/ 
function clearSearchByNameField(){
	var $ = jQuery.noConflict();
	var serachByNameInput = $('[id$="modalSearchByName"]');
	if(serachByNameInput){
		serachByNameInput.val('');
	}
	if($('.searchMemberItem')){
		if($('.searchMemberItem').children()){
			$('.searchMemberItem').children().remove();
		}
	}
}

/************************************************************
	Purpose: Removing Member on UI and passing id of deleted 
		     user id to backend method
*************************************************************/
function delMemeber(elemId){
	var $ = jQuery.noConflict();
	lockUI();
	var divId = 'userId_'+elemId;
	$('#'+divId).slideUp(100, function() {
		$('#'+divId).remove();
	});
	
	var numOfMembers = $('#'+divId).parent().find('span[id="groupMembersCount"]');
	
	if(numOfMembers){
		try{
			numOfMembers.html(parseInt(numOfMembers.html()) -1);
		}catch(e){
			
		}
	}
	
	deleteMember(elemId);
}

/************************************************************
	Purpose: 
*************************************************************/
function deleteFromUI(){
	
}

/************************************************************
	Purpose: Method block UI 
*************************************************************/
function lockUI(){
	var $ = jQuery.noConflict();
	$.blockUI({ css: { 
	border: 'none', 
	padding: '15px', 
	backgroundColor: '#000', 
	'-webkit-border-radius': '10px', 
	'-moz-border-radius': '10px', 
	opacity: .5, 
	color: '#fff' 
	},
	message: 'Please wait...' }); 
}

/************************************************************
	Purpose: Method collapse all members in all group 
*************************************************************/
function collapseMembers(){
	var $ = jQuery.noConflict();
	var expandIconprefix = 'groupName_Expand_';
	var colapseIconprefix = 'groupName_Colapse_';
	$('[id $= suggestedMembersContainer]').find('div[id^="userId_"]').hide();
	$('[id $= suggestedMembersContainer]').find('div[id^='+expandIconprefix+']').show();
	$('[id $= suggestedMembersContainer]').find('div[id^='+colapseIconprefix+']').hide();
}

/************************************************************
	Purpose: Method expand all members in all group 
*************************************************************/
function expandMembers(){
	var $ = jQuery.noConflict();
	var expandIconprefix = 'groupName_Expand_';
	var colapseIconprefix = 'groupName_Colapse_';
	$('[id $= suggestedMembersContainer]').find('div[id^="userId_"]').show();
	$('[id $= suggestedMembersContainer]').find('div[id^='+expandIconprefix+']').hide();
	$('[id $= suggestedMembersContainer]').find('div[id^='+colapseIconprefix+']').show();
	
}

/************************************************************
	Purpose: Method collapse all members in specific group
*************************************************************/
function colapseGroup(elementId){
	var $ = jQuery.noConflict();
	var elementFullId = 'groupName_'+elementId;
	var parentElement = $('div[id='+elementFullId+']');
	if(parentElement){
		parentElement.find('div[id^="userId_"]').hide();
	}
	var expandIconId = 'groupName_Expand_'+elementId;
	var colapseIconId = 'groupName_Colapse_'+elementId;
	var expandIconElement = $('div[id='+expandIconId+']');
	var colapseIconElement = $('div[id='+colapseIconId+']');
	if(expandIconElement){
		expandIconElement.show();
	}
	if(colapseIconElement){
		colapseIconElement.hide();
	}
}

/************************************************************
	Purpose: Method expand all members in specific group
*************************************************************/
function expandGroup(elementId){
	var $ = jQuery.noConflict();
	var elementFullId = 'groupName_'+elementId;
	var parentElement = $('div[id='+elementFullId+']');
	if(parentElement){
		parentElement.find('div[id^="userId_"]').show();
	}
	var expandIconId = 'groupName_Expand_'+elementId;
	var colapseIconId = 'groupName_Colapse_'+elementId;
	var expandIconElement = $('div[id='+expandIconId+']');
	var colapseIconElement = $('div[id='+colapseIconId+']');
	if(expandIconElement){
		expandIconElement.hide();
	}
	if(colapseIconElement){
		colapseIconElement.show();
	}
}    

/************************************************************
	Purpose: Unlocking UI
*************************************************************/
function unlockUI(){
	var $ = jQuery.noConflict();
	$.unblockUI();
}


/************************************************************
	Purpose: Expand all group memeber when suggestem member form is rerender 
	         e.g when new users are added
*************************************************************/
function clearExpandColapseAfterRender(){
	var $ = jQuery.noConflict();
	var itemsToHide = $('div[id^="groupName_Expand_"]');
	if(itemsToHide){
		itemsToHide.hide();
	}
	var itemsToHideExternal = $('div[id="groupExternal_Expand"]');
	if(itemsToHideExternal){
		itemsToHideExternal.hide();
	}
}