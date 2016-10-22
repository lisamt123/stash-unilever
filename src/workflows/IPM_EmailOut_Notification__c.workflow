<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Notify_Finance_Leader_about_TLD_change</fullName>
        <ccEmails>mukul.mudgal@cognizant.com</ccEmails>
        <description>IPM Notify Finance Leader about TLD change</description>
        <protected>false</protected>
        <recipients>
            <field>To_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_Notify_Finance_Leader_about_TLD_is_changed_on_IPM_EmailOut_Notification</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_Project_Leader_for_FL_TLD_confirmation_for_Original_Project</fullName>
        <description>IPM Notify Project Leader for FL TLD confirmation for Original Project</description>
        <protected>false</protected>
        <recipients>
            <field>To_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_Notify_Project_Leader_about_FL_confirm_TLD_change_On_Email_Notification_Obj</template>
    </alerts>
    <rules>
        <fullName>IPM Notify Finance Leader about TLD is changed</fullName>
        <actions>
            <name>IPM_Notify_Finance_Leader_about_TLD_change</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.To_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.Target_Launch_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.Project_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.Previous_Target_Launch_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IPM Notify Project Leader about TLD confirmation by Fin Leader for Original Project</fullName>
        <actions>
            <name>IPM_Notify_Project_Leader_for_FL_TLD_confirmation_for_Original_Project</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.To_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.MCO_Country_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_EmailOut_Notification__c.Project_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
