/* -----------------------------------------------------------------------------------------------------------------------
Name: BC_landing_page.cls 
Description: 1) Class which handles the logic to fill the landing page of Brand Centre

Date Version Author Summary of Changes 
----------- ------- ----------------- ------------------------------------------------------------------------
November 2013 1.0 Vanessa Barros Initial Release 
------------------------------------------------------------------------------------------------------------------------ */
/*Change History*/
/********************************************************************************************************
Date Author Version Description Requested By Tag
--------------------------------------------------------------------------------------------------------------------------
14-October-2014 Dnyaneshwar Kendre 1.03 Fetching profiles through custom settings T2

11-August-2014 Blessy Voola 1.02 1 Profile added Unilever T1 

10-June-2014 Subhashish Sahu 1.01 2 Profiles Added Unilever T0

***************************************************************************************************************************/

public class BC_landing_page {


public string css {get;set;}
public string css_url;
public string dynamicCss;
public final Brand_centre_new__c brand_centre;
public string userId;
public boolean hasPermission;
public string communityHeader;
public string onlineHeader;
public string lastestNewsHeader;
public string preview {get;set;}
public string id {get;set;}
public string chatterGroup {get;set;}
public string backgroundImage;
public string footer;
public string static_resource;
public boolean ShowButton;


public BC_landing_page(ApexPages.StandardController controller) {
//getting Brand Centre id
id = System.currentPageReference().getParameters().get('id');

//getting user id (who is currently accessing )
userId = UserInfo.getUserId();

//getting the preview from the url
preview = System.currentPageReference().getParameters().get('preview');
//this.brand_centre = (Brand_centre_new__c)controller.getRecord();
brand_centre_new__c b = [select chatter_group_id__c from brand_centre_new__c where id = :System.currentPageReference().getParameters().get('id')];
system.debug('bbbbb'+b);
chatterGroup = b.chatter_group_id__c;
hasPermission= true;


}
//See if the user that is trying to access brand centre landing page have permission to see (if he is a chatter license member)

public PageReference getPermissionUser(){
User u = [select profile.name , UserType from User where id = :userId];  
system.debug('user'+ u.profile.name); 

/*T2 Start- Replaced hardcoded profile names with custom settings:BC Profile*/   

//u.profile.name <> 'System Administrator' || u.profile.name <> 'Unilever Way - Marketing - Standard Marketing User' || u.profile.name
// <> 'Unilever Way - Marketing - Brand Centre Admin' || u.profile.name == 'Unilever Way – Brand and Hub Admin' ||
//u.profile.name == 'Unilever Way - Marketing - System Administrator Lite'
//if(u.profile.name <> 'System Administrator' && u.profile.name <> 'Unilever Way - Marketing - Standard Marketing User' && u.profile.name
//<> 'Unilever Way - Marketing - Brand Centre Admin' && u.profile.name <> 'Unilever Way - Marketing - Brand and HUB Admin' &&
//u.profile.name <> 'Unilever Way - Marketing - System Administrator Lite' && /* T0 */ u.profile.name <> 'Unilever - Force MultiApp Standard' && 
//u.profile.name <> 'Unilever - Force MultiApp Marketing'/*T1*/&&u.profile.name<>'Unilever Way - Marketing - HUB Admin')


set<string> bcUniqueProfiles = new set< string >();

for(BC_Profile__c BCprofile: [SELECT Name, profile__c, Id FROM BC_Profile__c])  //For fetching the Profiles having permission from custom settings:'BC Profile'.
{
bcUniqueProfiles.add(BCprofile.Profile__c);
}
boolean result =bcUniqueProfiles.contains(u.profile.name);
If (!result)
{
PageReference p = new PageReference('/_ui/core/chatter/groups/GroupProfilePage?g='+chatterGroup); 
p.setRedirect(true);
hasPermission = false;
return p;
}
return null;
}  /*T2 End*/
    
//Dynamic CSS - Method that discover what css to use. this fetch the css parameter from the url and build the css url to upload the correct
//css for each brand centre page
public string getDynamicCss (){

if(hasPermission== true){ 
//getting css name 
Brand_centre_new__c b = [select static_resource_name__c,css_name__c from brand_centre_new__c where id=:id]; 
css_url = b.css_name__c;
system.debug('css_url' + css_url) ; 
static_resource = b.static_resource_name__c;
Try{ 
StaticResource resource = [SELECT Name, NamespacePrefix, SystemModStamp FROM StaticResource WHERE Name = :static_resource LIMIT 1];
system.debug('resource' + resource) ; 


if(resource!=null){

String namespace = resource.NamespacePrefix;

dynamicCss = URL.getSalesforceBaseUrl().toExternalForm() + '/resource/' + resource.SystemModStamp.getTime() + '/' + 
(namespace != null && namespace != '' ? namespace + '__' : '') + static_resource+'/'+ css_url+'.css';

system.debug('dynamicCss'+ dynamicCss);

}else{
dynamicCss = '';
}

return dynamicCss; 
} catch(Exception ex){
return null;
} 
}return null; 
}
//getting background Image
public string getBackgroundImage (){
Brand_centre_new__c b = [select background_image__c from brand_centre_new__c where id=:id]; 
if(b.background_image__c <> null){
backgroundImage = b.background_image__c.substringAfter('src="').substringBefore('"');
if(backgroundImage.contains ('&amp;')){
backgroundImage = backgroundImage.replace('&amp;','&'); 
}
}
return backgroundImage;
}

//getting footer image
public string getFooter (){
Brand_centre_new__c b = [select footer__c from brand_centre_new__c where id=:id]; 
if(b.footer__c <> null){
footer = b.footer__c.substringAfter('src="').substringBefore('"');
if(footer .contains ('&amp;')){
footer = footer .replace('&amp;','&'); 
}
} 
return footer ;
}


//getting the Community title
public string getCommunityHeader(){
try{ 
if(preview == 'true' ){
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Community' and header__c = true and 
brand_centre__c= :id limit 1];

communityHeader = b.name; 

}else{
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Community' and header__c = true 
and brand_centre__c= :id and display__c = true limit 1];

communityHeader = b.name; 
}
return communityHeader;
}catch(exception ex){
return null;
}
}

//getting community content
public List<Brand_centre_content__c> getCommunityContent(){
try{

List<Brand_centre_content__c> CommunityContent = new List<Brand_centre_content__c> ();
if(preview== 'true'){
CommunityContent = [select name, Link_URL__c from Brand_centre_content__c where brand_centre__c= :id 
and header_section__r.position__c = 'Community' order by Ordinal__c ASC];
}else{
CommunityContent = [select name, Link_URL__c from Brand_centre_content__c where brand_centre__c= :id 
and display__c =true and header_section__r.position__c = 'Community' order by Ordinal__c ASC];
}
return CommunityContent;
}catch (exception ex){
return null;
}
}

//getting the center title
public string getLastestNewsHeader(){
try{
if(preview == 'true'){
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Latest News' and header__c = true 
and brand_centre__c= :id and header__c = true limit 1];
lastestNewsHeader= b.name;
}else{
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Latest News' and header__c =true and 
brand_centre__c= :id and header__c = true and display__c =true];
lastestNewsHeader= b.name; 
} 
return lastestNewsHeader;
}catch (exception ex){
return null;
}
}

//getting Lastest News content
public List<Brand_centre_content__c> getLastestNewsContent(){
try{
List<Brand_centre_content__c> LastestNewsContent = new List<Brand_centre_content__c> ();
if(preview == 'true'){
List<Brand_centre_content__c> l = [select name, preview_image_id__c, published_date__c,preview_image2__c,target__c,ordinal__c, 
Front_End_link__c, summary__c,brand_centre__r.id from Brand_centre_content__c
where brand_centre__c= :id and header_section__r.position__c = 'Latest News' and ordinal__c <> null
order by ordinal__c ASC ];

List<Brand_centre_content__c> l1 = [select name, preview_image_id__c, published_date__c,preview_image2__c,target__c,ordinal__c, 
Front_End_link__c, summary__c,brand_centre__r.id from Brand_centre_content__c
where brand_centre__c= :id and header_section__r.position__c = 'Latest News' and ordinal__c = null
order by published_date__c Desc ];

if(l.size()>0){
LastestNewsContent.addAll(l);
}
if(l1.size()>0){
LastestNewsContent.addAll(l1);
}
}else{
List<Brand_centre_content__c> l = [select name, preview_image_id__c, published_date__c,preview_image2__c,target__c,ordinal__c, 
Front_End_link__c, summary__c,brand_centre__r.id from Brand_centre_content__c
where brand_centre__c= :id and display__c =true and header_section__r.position__c = 'Latest News' and ordinal__c <> null
order by ordinal__c ASC ];

List<Brand_centre_content__c> l1 = [select name, preview_image_id__c, published_date__c,preview_image2__c,target__c,ordinal__c, 
Front_End_link__c, summary__c,brand_centre__r.id from Brand_centre_content__c
where brand_centre__c= :id and display__c =true and header_section__r.position__c = 'Latest News' and ordinal__c = null
order by published_date__c Desc ];

if(l.size()>0){
LastestNewsContent.addAll(l);
}
if(l1.size()>0){
LastestNewsContent.addAll(l1);
}


}
return LastestNewsContent;
}catch(exception ex){
return null;
}
}

//getting the Online title
public string getOnlineHeader(){
try{
if(preview== 'true'){
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Online' and brand_centre__c= :id
and header__c = true limit 1];
onlineHeader= b.name; 
}else{
Brand_centre_content__c b = [select name from brand_centre_content__c where position__c = 'Online' and brand_centre__c= :id
and header__c = true and display__c =true];
onlineHeader= b.name; 
} 
return onlineHeader;
}catch (exception ex){
return null;
}
}

//getting online content
public List<Brand_centre_content__c> getOnlineContent(){
try{
List<Brand_centre_content__c> OnlineContent = new List<Brand_centre_content__c>();
if(preview == 'true'){
OnlineContent= [select name, Link_URL__c, icon__c from Brand_centre_content__c where brand_centre__c= :id 
and header_section__r.position__c = 'online' order by ordinal__c Asc ];
}else{
OnlineContent= [select name, Link_URL__c, icon__c from Brand_centre_content__c where brand_centre__c= :id 
and display__c =true and header_section__r.position__c = 'online' order by ordinal__c Asc];
}
return OnlineContent;
}catch(exception ex){
return null;
}
}
//getting right Side Menu header
public List<Brand_centre_content__c> getRightSideMenu(){
try{
List<brand_centre_content__c> RightSideMenu = new List<brand_centre_content__c> ();
if(preview == 'true'){
RightSideMenu = [select name, ordinal__c from brand_centre_content__c where position__c = 'Right Side' and brand_centre__c= :id
and header__c = true order by Ordinal__c Asc];
}else{
RightSideMenu = [select name, ordinal__c from brand_centre_content__c where position__c = 'Right Side' and brand_centre__c= :id
and header__c = true and display__c =true order by Ordinal__c Asc];
}

return RightSideMenu;
}catch(exception ex){
return null;
}
}

//getting right side content 
public List<Brand_centre_content__c> getRightSideHeaderContent(){
try{
List<Brand_centre_content__c> RightSideHeaderContent = new List<Brand_centre_content__c> ();
if(preview== 'true'){
RightSideHeaderContent= [select name, Link_URL__c, header_section__c from Brand_centre_content__c where brand_centre__c= :id 
and header_section__r.position__c = 'Right Side' order by ordinal__c Asc];
}else{
RightSideHeaderContent= [select name, Link_URL__c, header_section__c from Brand_centre_content__c where brand_centre__c= :id 
and display__c =true and header_section__r.position__c = 'Right Side' order by ordinal__c Asc];
}
return RightSideHeaderContent;
}catch(exception ex){
return null;
}
}

//getting the members of the chatter group
Public List<User> getMembers (){
List<CollaborationGroupMember> m = [Select MemberId from CollaborationGroupMember where CollaborationGroupId =:chatterGroup limit 1000];
if(m.size()>0){
system.debug('members'+ m);

Set<id> userID = new set<id>();

for(CollaborationGroupMember mem :m ){
userID.add(mem.MemberId); 
}

if(userId.size()>0){
List<User> members = [select FullPhotoUrl, name, id from User where id in :userID];
return members;
}else{
return null;
}
}
return null;

}
//function that determines if the button join group is displayed in the front end - if the user is a member this is not be displayed
//if no, the button will appear
public boolean getShowButton(){
try{
CollaborationGroupMember m = [Select MemberId from CollaborationGroupMember where CollaborationGroupId =:chatterGroup and MemberId =:userId]; 
system.debug('mmmm'+m);
ShowButton = false; 
}catch(Exception ex){
ShowButton = TRUE; 
}
return ShowButton;

}
//when a user is not a member of the related chatter group, he can join through the front end
Public PageReference joinGroup (){
try{
CollaborationGroupMember m = new CollaborationGroupMember (CollaborationGroupId = chatterGroup,MemberId =userId);
insert m; 

ShowButton = false; 
}catch(Exception ex){
ShowButton = true; 
} 
return null;
}




}