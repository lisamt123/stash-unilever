<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_To_send_an_email_to_functional_role_members</fullName>
        <description>To send an email to functional role members</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Member_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/IPM_Send_notification_to_members</template>
    </alerts>
    <fieldUpdates>
        <fullName>IPM_Insert_user_email</fullName>
        <field>IPM_Member_Email__c</field>
        <formula>IPM_User__r.Email</formula>
        <name>IPM Insert user email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Notification</fullName>
        <field>IPM_send_an_email__c</field>
        <literalValue>0</literalValue>
        <name>IPM Update Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM Update Email</fullName>
        <actions>
            <name>IPM_Insert_user_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IPM email notification</fullName>
        <actions>
            <name>IPM_To_send_an_email_to_functional_role_members</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>IPM_Update_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Project_Resource__c.IPM_send_an_email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send an email to all members associated with functional role and section</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
