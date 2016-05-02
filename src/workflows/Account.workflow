<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CEC_Account_Email_Notification</fullName>
        <ccEmails>ulcecsupport.in@capgemini.com</ccEmails>
        <description>CEC Account Email Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_Account_Email_Notification</template>
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
</Workflow>
