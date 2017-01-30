<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_request_email_template_to_Step2</fullName>
        <description>&quot;Approval request email template&quot; to Step 2 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_System_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Owner_Changes_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_1</fullName>
        <description>&quot;Approval request email template&quot; to Step 1 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_System_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Owner_Changes_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_approver_for_Final_Approval</fullName>
        <description>&quot;Approval request email template&quot; to approver for Final Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_System_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/NAFS_Operator_Account_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>CEC_Account_Email_Notification</fullName>
        <ccEmails>ulcecsupport.in@capgemini.com</ccEmails>
        <description>CEC Account Email Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_Account_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>FS_Account_Validation_Reject_From_Admin_Group</fullName>
        <description>Account Validation Reject From Admin Group</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Validation_Reject_From_Admin_Group</template>
    </alerts>
    <alerts>
        <fullName>FS_Account_Validation_Reject_From_Manager</fullName>
        <description>FS Account Validation Reject From Manager</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Validation_Reject_From_Manager</template>
    </alerts>
    <alerts>
        <fullName>FS_Proposed_Account_Owner_Nomination</fullName>
        <description>FS Proposed Account Owner Nomination Sent For Approval</description>
        <protected>false</protected>
        <recipients>
            <field>FS_ProposedAccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Proposed_Account_Owner_Nomination</template>
    </alerts>
    <alerts>
        <fullName>FS_Proposed_Account_Owner_Nomination_Rejected</fullName>
        <description>Proposed Account Owner Nomination Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>FS_ProposedAccountOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Proposed_Account_Owner_Nomination_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEC_Capitalise_the_consumers_First_name</fullName>
        <description>CEC - Make the FirstName&apos;s letter uppoer case for the first letter of the word and the letter which follows space or hyphen.</description>
        <field>FirstName</field>
        <formula>IF (
	NOT(OR(CONTAINS(FirstName,&quot; &quot;),CONTAINS(FirstName ,&quot;-&quot;))), UPPER(LEFT(FirstName ,1))&amp;LOWER(MID(FirstName,2,LEN(FirstName)-1)),
	IF(CONTAINS(FirstName,&quot; &quot;),
			IF(FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName)-FIND(&quot; &quot;,FirstName,1)))=0,
			UPPER(LEFT(FirstName ,1))&amp;
			LOWER(MID(FirstName ,2,FIND(&quot; &quot;,FirstName ,1)-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+2,LEN(FirstName)-1)),
			UPPER(LEFT(FirstName ,1))&amp;
			LOWER(MID(FirstName ,2,FIND(&quot; &quot;,FirstName ,1)-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+2,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))+FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))+FIND(&quot; &quot;,FirstName ,1)+2,LEN(FirstName)-1))
	),
	IF(CONTAINS(FirstName,&quot;-&quot;),
			IF(FIND(&quot;-&quot;,MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,LEN(FirstName)-FIND(&quot;-&quot;,FirstName,1)))=0,
			UPPER(LEFT(FirstName ,1))&amp;
			LOWER(MID(FirstName ,2,FIND(&quot;-&quot;,FirstName ,1)-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+2,LEN(FirstName)-1)),
			UPPER(LEFT(FirstName ,1))&amp;
			LOWER(MID(FirstName ,2,FIND(&quot;-&quot;,FirstName ,1)-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+2,FIND(&quot;-&quot;,MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot;-&quot;,FirstName ,1)))-1))&amp;
			UPPER(MID(FirstName ,FIND(&quot;-&quot;,MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot;-&quot;,FirstName ,1)))+FIND(&quot;-&quot;,FirstName ,1)+1,1))&amp;
			LOWER(MID(FirstName ,FIND(&quot;-&quot;,MID(FirstName ,FIND(&quot;-&quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot;-&quot;,FirstName ,1)))+FIND(&quot;-&quot;,FirstName ,1)+2,LEN(FirstName)-1))
	),
	FirstName))
)</formula>
        <name>CEC Capitalise the consumers First name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Capitalise_the_consumers_Last_name</fullName>
        <description>CEC - Make the LastName&apos;s letter uppoer case for the first letter of the word and the letter which follows space or hyphen</description>
        <field>LastName</field>
        <formula>IF (
	NOT(OR(CONTAINS(LastName,&quot; &quot;),CONTAINS(LastName ,&quot;-&quot;))), UPPER(LEFT(LastName ,1))&amp;LOWER(MID(LastName,2,LEN(LastName)-1)),
	IF(CONTAINS(LastName,&quot; &quot;),
			IF(FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName)-FIND(&quot; &quot;,LastName,1)))=0,
			UPPER(LEFT(LastName ,1))&amp;
			LOWER(MID(LastName ,2,FIND(&quot; &quot;,LastName ,1)-1))&amp;
			UPPER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+2,LEN(LastName)-1)),
			UPPER(LEFT(LastName ,1))&amp;
			LOWER(MID(LastName ,2,FIND(&quot; &quot;,LastName ,1)-1))&amp;
			UPPER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+2,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))-1))&amp;
			UPPER(MID(LastName ,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))+FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))+FIND(&quot; &quot;,LastName ,1)+2,LEN(LastName)-1))
	),
	IF(CONTAINS(LastName,&quot;-&quot;),
			IF(FIND(&quot;-&quot;,MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,LEN(LastName)-FIND(&quot;-&quot;,LastName,1)))=0,
			UPPER(LEFT(LastName ,1))&amp;
			LOWER(MID(LastName ,2,FIND(&quot;-&quot;,LastName ,1)-1))&amp;
			UPPER(MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+2,LEN(LastName)-1)),
			UPPER(LEFT(LastName ,1))&amp;
			LOWER(MID(LastName ,2,FIND(&quot;-&quot;,LastName ,1)-1))&amp;
			UPPER(MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+2,FIND(&quot;-&quot;,MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot;-&quot;,LastName ,1)))-1))&amp;
			UPPER(MID(LastName ,FIND(&quot;-&quot;,MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot;-&quot;,LastName ,1)))+FIND(&quot;-&quot;,LastName ,1)+1,1))&amp;
			LOWER(MID(LastName ,FIND(&quot;-&quot;,MID(LastName ,FIND(&quot;-&quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot;-&quot;,LastName ,1)))+FIND(&quot;-&quot;,LastName ,1)+2,LEN(LastName)-1))
	),
	LastName))
)</formula>
        <name>CEC Capitalise the consumers Last name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Consumer_Country_Updates</fullName>
        <description>CEC: To update the consumer country field for NA</description>
        <field>PersonMailingCountry</field>
        <formula>IF(OR(Upper(PersonMailingCountry) = &apos;USA&apos;, Upper(PersonMailingCountry) = &apos;US&apos;), &apos;United States&apos;, IF(OR(Upper(PersonMailingCountry) = &apos;CAN&apos;,Upper(PersonMailingCountry) = &apos;CA&apos; ),&apos;Canada&apos;,&apos;Mexico&apos;))</formula>
        <name>CEC Consumer Country Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_LocalIdentifierNoSpecialChar_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Local_Identifier__c&apos; field and update the custom field Local_Identifier_No_Special_Char__c.</description>
        <field>Local_Identifier_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE( Local_Identifier__c , &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC LocalIdentifierNoSpecialChar Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_LocalIdentifierSpecialChar_Update</fullName>
        <description>CEC  This will update Local_Identifier_No_Special_Char__c field with Local_Identifier__c</description>
        <field>Local_Identifier_No_Special_Char__c</field>
        <formula>Local_Identifier__c</formula>
        <name>CEC LocalIdentifier Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_NoSpecialChar_Home_Phone_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Home Phone&apos; field and update the custom field.</description>
        <field>Home_Phone_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(PersonHomePhone, &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC_NoSpecialChar Home Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_NoSpecialChar_Mobile_Phone_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Mobile Phone&apos; field and update the custom field.</description>
        <field>Mobile_Phone_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(PersonMobilePhone, &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC_NoSpecialChar Mobile Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_NoSpecialChar_Other_Phone_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Other Phone&apos; field and update the custom field.</description>
        <field>Other_Phone_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(PersonOtherPhone, &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC_NoSpecialChar Other Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_NoSpecialChar_Phone_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Phone&apos; field and update the custom field.</description>
        <field>Phone_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone, &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC_NoSpecialChar Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FSNA_Concatenate_Shipping_St_Address2</fullName>
        <field>ShippingStreet</field>
        <formula>ShippingStreet + &quot;  &quot; +  CHD__Address2__c</formula>
        <name>Concatenate Shipping Street and Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Status_Update_New</fullName>
        <description>This field Update is used to update Status from Temporary to New after LM and Admin aproved</description>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Status Update New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateAccountNumber</fullName>
        <field>AccountNumber</field>
        <formula>FS_Customer_Number__c</formula>
        <name>Update Account Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateAccountStatus</fullName>
        <description>Update Account Status</description>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Update Account Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateOffInvoice</fullName>
        <description>Update Off Invoice field based on initial set up in custom settings</description>
        <field>FS_offInvoice__c</field>
        <formula>CASE( FS_Distributor_Type__c, 
&apos;Strategic&apos;, $Setup.FS_DistributorTypeStrategic__c.FS_Off_Invoice__c, 
&apos;Partner&apos;, $Setup.FS_DistributorTypePartner__c.FS_Off_Invoice__c, 
&apos;Logist&apos;, $Setup.FS_DistributorTypeLogist__c.FS_Off_Invoice__c, 
&apos;Direct&apos;, $Setup.FS_DistributorTypeDirectClient__c.FS_Off_Invoice__c, 
&apos;C&amp;C&apos;, $Setup.FS_DistributorTypeCnC__c.FS_Off_Invoice__c, 
&apos;Slabco&apos;, $Setup.FS_DistributorTypeSlabco__c.FS_Off_Invoice__c, 
0.00)</formula>
        <name>Update Off Invoice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_UpdateProposedAccountOwner</fullName>
        <field>FS_ProposedAccountOwner__c</field>
        <name>Update Proposed Account Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_On_Invoice</fullName>
        <description>Update On invoice field based on initial set up in custom settings</description>
        <field>FS_onInvoice__c</field>
        <formula>CASE(  FS_Distributor_Type__c, 
&apos;Strategic&apos;, $Setup.FS_DistributorTypeStrategic__c.FS_On_Invoice__c,
&apos;Partner&apos;, $Setup.FS_DistributorTypePartner__c.FS_On_Invoice__c, 
&apos;Logist&apos;, $Setup.FS_DistributorTypeLogist__c.FS_On_Invoice__c, 
&apos;Direct&apos;, $Setup.FS_DistributorTypeDirectClient__c.FS_On_Invoice__c,
&apos;C&amp;C&apos;, $Setup.FS_DistributorTypeCnC__c.FS_On_Invoice__c, 
&apos;Slabco&apos;, $Setup.FS_DistributorTypeSlabco__c.FS_On_Invoice__c,
0.00)</formula>
        <name>Update On Invoice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Sales_Org</fullName>
        <description>If US, 0002, If CA, 0003</description>
        <field>Sales_ORG__c</field>
        <formula>IF(OR(ShippingCountry=&quot;CA&quot;,ShippingCountry = &quot;Canada&quot;),&quot;0003&quot;,&quot;0002&quot;)</formula>
        <name>FS Update Sales Org</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NAFS_Account_status_Update_to_Temporary</fullName>
        <description>Account status update to Temporary if type is operator</description>
        <field>Status__c</field>
        <literalValue>Temporary</literalValue>
        <name>NAFS Account Status Update to Temporary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Off_Invoice_Update</fullName>
        <field>FS_offInvoice__c</field>
        <formula>Parent.FS_offInvoice__c</formula>
        <name>Off Invoice Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_Invoice_Update</fullName>
        <field>FS_onInvoice__c</field>
        <formula>Parent.FS_onInvoice__c</formula>
        <name>On Invoice Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposed_acount_owner_update</fullName>
        <description>If approved proposed account owner will be updated to Null</description>
        <field>FS_ProposedAccountOwner__c</field>
        <name>Proposed acount owner update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>FS_OperatorRussia</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Supply_Cost_Update</fullName>
        <field>FS_supplyCost__c</field>
        <formula>Parent.FS_supplyCost__c</formula>
        <name>Supply Cost Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Number</fullName>
        <description>Update the account Number from the External Id.</description>
        <field>AccountNumber</field>
        <formula>External_Id__c</formula>
        <name>Update Account Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC Account Email Notification</fullName>
        <actions>
            <name>CEC_Account_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow is to send the email notification when account is created with mulesoft user owner id</description>
        <formula>IF(OwnerId == $Setup.cec_Org_Settings__c.Mulesoft_User_Id__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC Capitalise the consumers name</fullName>
        <actions>
            <name>CEC_Capitalise_the_consumers_First_name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_Capitalise_the_consumers_Last_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.FirstName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <description>CEC - Change the FirstName and LastName to Camel Case format.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC NA Consumer Country Updates</fullName>
        <actions>
            <name>CEC_Consumer_Country_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC: Workflow rule to update the consumer country from USA/CAN/MEX to United States/Canada/Mexico</description>
        <formula>AND(IsPersonAccount = TRUE,OR(UPPER(PersonMailingCountry) = &apos;USA&apos;,UPPER(PersonMailingCountry) = &apos;US&apos;,UPPER(PersonMailingCountry) = &apos;CAN&apos;,UPPER(PersonMailingCountry) = &apos;MEX&apos;, UPPER(PersonMailingCountry) = &apos;CA&apos;,UPPER(PersonMailingCountry) = &apos;MX&apos;), OR( Owner.UserRole.Name = &apos;CEC Global Head&apos;, Owner.UserRole.Name = &apos;CEC Manager - North America&apos;, Owner.UserRole.Name = &apos;CEC User - North America&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_HomePhoneRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_NoSpecialChar_Home_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the standard &apos;Home Phone&apos; field and copy to a custom field.</description>
        <formula>/* ---------------------------------------------------- 1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula. The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required. 2. !ISBLANK(Phone) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/ RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED(PersonAssistantPhone) || ISNEW() || !ISBLANK(PersonHomePhone) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_LocalIdentifier</fullName>
        <actions>
            <name>CEC_LocalIdentifierSpecialChar_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To copy &apos;Local Identifier&apos; field  in to Local_Identifier_No_Special_Char__c</description>
        <formula>/* ----------------------------------------------------  1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula.  The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required.  2. !ISBLANK(Local_Identifier__c) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/ RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED(Local_Identifier__c) || ISNEW() || !ISBLANK(Local_Identifier__c) ) &amp;&amp;  (  $UserRole.Name   &lt;&gt;  &apos;CEC Manager - Brazil&apos;  &amp;&amp;  $UserRole.Name   &lt;&gt;  &apos;CEC User - Planitox Brazil&apos;   &amp;&amp;   $UserRole.Name   &lt;&gt;  &apos;CEC User - Brazil&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_LocalIdentifierRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_LocalIdentifierNoSpecialChar_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the &apos;Local Identifier&apos; field and copy to a custom field Local_Identifier_No_Special_Char__c</description>
        <formula>/* ----------------------------------------------------  1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula.  The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required.  2. !ISBLANK(Local_Identifier__c) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/ RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED(Local_Identifier__c) || ISNEW() || !ISBLANK(Local_Identifier__c) ) &amp;&amp;  (  $UserRole.Name  = &apos;CEC Manager - Brazil&apos; || $UserRole.Name  = &apos;CEC User - Planitox Brazil&apos; || $UserRole.Name  = &apos;CEC User - Brazil&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_MobilePhoneRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_NoSpecialChar_Mobile_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the standard &apos;Home Phone&apos; field and copy to a custom field.</description>
        <formula>/* ---------------------------------------------------- 1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula. The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required. 2. !ISBLANK(Phone) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/ RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED( PersonMobilePhone) || ISNEW() || !ISBLANK(PersonMobilePhone) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_OtherPhoneRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_NoSpecialChar_Other_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the standard &apos;Other Phone&apos; field and copy to a custom field.</description>
        <formula>/* ---------------------------------------------------- 1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula. The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required. 2. !ISBLANK(Phone) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/ RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED( PersonOtherPhone) || ISNEW() || !ISBLANK(PersonOtherPhone) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CEC_PhoneRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_NoSpecialChar_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the standard &apos;Phone&apos; field and copy to a custom field.</description>
        <formula>/* ----------------------------------------------------  1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula.  The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required.  2. !ISBLANK(Phone) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/   RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED(Phone) || ISNEW() || !ISBLANK(Phone) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Concatenate Shipping Street and Address 2</fullName>
        <actions>
            <name>FSNA_Concatenate_Shipping_St_Address2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Operator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CHD__Address2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Concatenate Shipping Street and CHD Address 2</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FS Account Number Distributor</fullName>
        <actions>
            <name>Update_Account_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the account number field from the External Id for Distributor accounts created in Salesforce.com</description>
        <formula>AND( RecordType.DeveloperName =&quot;Distributor&quot;, $Profile.Name =&quot;Unilever Food Solution - Russia&quot;,  ISPICKVAL(CurrencyIsoCode, &apos;RUB&apos;)  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FS Account Status to Temporary</fullName>
        <actions>
            <name>NAFS_Account_status_Update_to_Temporary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created for set account status value to Temporary when type is equals to Operator.</description>
        <formula>CONTAINS(RecordType.DeveloperName, &quot;Operator&quot;) &amp;&amp; 
    CONTAINS(  Text(Type)   , &quot;Operator&quot;) &amp;&amp;
   $Profile.Name  &lt;&gt;  &quot;Generic API Only&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FS Distributor Type Information Update on Child from Parent Account</fullName>
        <actions>
            <name>Off_Invoice_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>On_Invoice_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Supply_Cost_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS Populate On%2FOff Invoice</fullName>
        <actions>
            <name>FS_UpdateOffInvoice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FS_Update_On_Invoice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is use to populate default value of On/Off Invoice from the custom settings</description>
        <formula>ISCHANGED(FS_Distributor_Type__c) &amp;&amp; ISBLANK(Parent.Name)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS Sales Org</fullName>
        <actions>
            <name>FS_Update_Sales_Org</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Shipping Country = &quot;CA&quot; or &quot;Canada&quot;  then  Sales Org=0003  else Sales Org=0002.</description>
        <formula>AND( OR(ShippingCountry = &quot;CA&quot;, ShippingCountry = &quot;Canada&quot;,ShippingCountry &lt;&gt; null), RecordType.DeveloperName =&quot;Operators&quot; ,$Profile.Name=&quot;Unilever Food Solution - NA&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS Update Operator Account Number</fullName>
        <actions>
            <name>FS_UpdateAccountNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For distributor unique ID generated by SAP. For operator accounts, unique ID generated by SFDC.</description>
        <formula>RecordType.DeveloperName =&apos;Operators&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FS Update operator record type on edit</fullName>
        <actions>
            <name>Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created to update the distributor type,on invoice,off invoice values from parent account.</description>
        <formula>AND(Owner.Profile.Name  = &apos;Unilever Food Solution - Russia&apos;, RecordType.Name = &apos;Operator&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
