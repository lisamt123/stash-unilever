<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_for_Admin_user_pref</fullName>
        <description>Alert for Admin user pref</description>
        <protected>false</protected>
        <recipients>
            <recipient>michaela.stewart@unilever.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>michaela.stewart@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>FA_Email_Template/FA_Alert_for_Admin_Mail</template>
    </alerts>
    <rules>
        <fullName>FA_AlertforAdmin_UserPre</fullName>
        <actions>
            <name>Alert_for_Admin_user_pref</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>FA_UserPreference__c.LastModifiedById</field>
            <operation>equals</operation>
            <value>FA_Occurence_Member__r.FA_Participant_Instructor__c</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
