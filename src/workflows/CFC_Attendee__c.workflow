<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Conference_Event_Reminder</fullName>
        <description>Conference Event Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Attendee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Conference_App/Conference_Event_Reminder</template>
    </alerts>
    <rules>
        <fullName>Conference App Event Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CFC_Attendee__c.Attendee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Conference_Event_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CFC_Attendee__c.TF_Event_From_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
