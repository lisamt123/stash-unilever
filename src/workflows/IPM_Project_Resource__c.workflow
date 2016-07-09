<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Send_email_to_team_resources_when_project_is_stopped</fullName>
        <description>IPM Send email to team resources when project is stopped</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_team_members_when_project_stopped</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_to_team_resources_when_project_reactivated</fullName>
        <description>IPM send email to team resources when project reactivated</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_when_project_reactivated</template>
    </alerts>
    <alerts>
        <fullName>IPM_To_send_an_email_to_functional_role_members</fullName>
        <description>To send an email to functional role members</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Res_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_section_notification2</template>
    </alerts>
    <fieldUpdates>
        <fullName>IPM_Insert_user_email</fullName>
        <field>IPM_Res_Email__c</field>
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
        <active>false</active>
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
        <description>send an email to all members associated with functional role and section</description>
        <formula>IPM_send_an_email__c=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ipm_updatefinancemember</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project_Resource__c.IPM_Project_Role_Owner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project_Resource__c.IPM_Role_Type__c</field>
            <operation>equals</operation>
            <value>Finance</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
