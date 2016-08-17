<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_request_email_template_to_Step2</fullName>
        <description>&quot;Approval request email template&quot; to Step 2 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>ramesh.suddapalli@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Owner_Changes_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_1</fullName>
        <ccEmails>ramesh.suddapalli@accenture.com</ccEmails>
        <description>&quot;Approval request email template&quot; to Step 1 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>jyotirmoy.sharma@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Owner_Changes_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_2</fullName>
        <description>&quot;Approval request email template&quot; to Step 2 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>ramesh.suddapalli@accenture.com</recipient>
            <type>user</type>
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
        <fullName>FS_SendanemailnotificationtoadminsManagersfordochangesonaccount</fullName>
        <description>Send an email notification to admins/Managers for  do changes on account</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_System_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Approval_request_for_required_changes</template>
    </alerts>
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
&apos;Strategic&apos;, $Setup.FSDistributorTypeStrategic__c.FS_Off_Invoice__c, 
&apos;Partner&apos;, $Setup.FSDistributorTypePartner__c.FS_Off_Invoice__c, 
&apos;Logist&apos;, $Setup.FSDistributorTypeLogist__c.FS_Off_Invoice__c, 
&apos;Direct&apos;, $Setup.FSDistributorTypeDirectClient__c.FS_Off_Invoice__c, 
&apos;C&amp;C&apos;, $Setup.FSDistributorTypeCnC__c.FS_Off_Invoice__c, 
&apos;Slabco&apos;, $Setup.FSDistributorTypeSlabco__c.FS_Off_Invoice__c, 
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
&apos;Strategic&apos;, $Setup.FSDistributorTypeStrategic__c.FS_On_Invoice__c,
&apos;Partner&apos;, $Setup.FSDistributorTypePartner__c.FS_On_Invoice__c, 
&apos;Logist&apos;, $Setup.FSDistributorTypeLogist__c.FS_On_Invoice__c, 
&apos;Direct&apos;, $Setup.FSDistributorTypeDirectClient__c.FS_On_Invoice__c,
&apos;C&amp;C&apos;, $Setup.FSDistributorTypeCnC__c.FS_On_Invoice__c, 
&apos;Slabco&apos;, $Setup.FSDistributorTypeSlabco__c.FS_On_Invoice__c,
0.00)</formula>
        <name>Update On Invoice</name>
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
    <outboundMessages>
        <fullName>FS_Update_required_changes</fullName>
        <apiVersion>37.0</apiVersion>
        <description>Created to send changes on account to external system.</description>
        <endpointUrl>http://putsreq.com</endpointUrl>
        <fields>FS_AmountOfVisitors__c</fields>
        <fields>FS_OperatorOutlet__c</fields>
        <fields>FS_Top_Client__c</fields>
        <fields>Fax</fields>
        <fields>Id</fields>
        <fields>Phone</fields>
        <fields>SegmentRussia__c</fields>
        <fields>Segment__c</fields>
        <fields>SubSegmentRussia__c</fields>
        <fields>SubSegment__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>ramesh.suddapalli@accenture.com</integrationUser>
        <name>FS Update required changes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Add Territory Information for NAFS users</fullName>
        <active>false</active>
        <formula>$Setup.FS_User_Territory__c.Territory__c = &apos;ABC&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
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
        <fullName>FS Account Status to Temporary</fullName>
        <actions>
            <name>NAFS_Account_status_Update_to_Temporary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>contains</operation>
            <value>Operator</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Operator</value>
        </criteriaItems>
        <description>Created for set account status value to Temporary when type is equals to Operator.</description>
        <triggerType>onCreateOnly</triggerType>
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
        <formula>ISCHANGED(FS_Distributor_Type__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS Send account changes to external system</fullName>
        <actions>
            <name>FS_Update_required_changes</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>To Send changes on account to external system.</description>
        <formula>AND( RecordType.Name = $Label.FS_AccountOperatorRecordType ,OR(ISCHANGED( FS_AmountOfVisitors__c), ISCHANGED( Phone ), ISCHANGED( Fax ) , ISCHANGED( PersonContactId ) , ISCHANGED( FS_OperatorOutlet__c ) , ISCHANGED(Segment__c), ISCHANGED( SegmentRussia__c ),  ISCHANGED( SubSegment__c ) , ISCHANGED( SubSegmentRussia__c ), ISCHANGED( FS_Top_Client__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS_Process</fullName>
        <active>false</active>
        <formula>AND(OR($Setup.FS_User_Territory__c.Territory__c = &apos;54100 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;54200 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55000 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55020 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55035 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55040 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55045 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;56025 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59020 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59025 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59045 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;89010 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;89015 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;89020 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55015 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55030 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59000 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59015 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59040 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;53000 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;53010 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;53015 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;53020 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59005 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;89100 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10500 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;59010 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;82100 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;82200 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10100 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;55005 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;56005 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;56015 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;56020 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10610 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10620 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10600 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10800 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;56010 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10007 Sales Rep&apos;, $Setup.FS_User_Territory__c.Territory__c = &apos;10200 Sales Rep&apos;), contains(Owner.UserRole.Name,&apos;Sales Rep&apos;), RecordType.Name=&apos;Operator&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS_Update Operator Account Number</fullName>
        <actions>
            <name>FS_UpdateAccountNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Operator</value>
        </criteriaItems>
        <description>For distributor unique ID generated by SAP. For operator accounts, unique ID generated by SFDC.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Top Client notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.FS_Top_Client__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Accounts_owner_changes_approval_required</fullName>
        <assignedTo>samanway.chakraborty@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Accounts owner changes approval required</subject>
    </tasks>
    <tasks>
        <fullName>Change_Account_Owner</fullName>
        <assignedTo>samanway.chakraborty@accenture.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Change Account Owner</subject>
    </tasks>
</Workflow>
