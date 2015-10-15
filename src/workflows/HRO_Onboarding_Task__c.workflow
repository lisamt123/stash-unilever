<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>HRO_Overdue_task_notifications</fullName>
        <description>HRO Overdue task notifications</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Overdue_task_notifications</template>
    </alerts>
    <rules>
        <fullName>HRO Overdue task notifications</fullName>
        <active>true</active>
        <criteriaItems>
            <field>HRO_Onboarding_Task__c.Completed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifications: Overdue task notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HRO_Overdue_task_notifications</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task__c.Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MarkOverDueTaskOnUsere</fullName>
        <active>false</active>
        <formula>Today()&gt;Due_Date__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
