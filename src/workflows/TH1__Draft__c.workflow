<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CEC_TH_Exception_Notification_Email_Alert</fullName>
        <description>CEC TH Exception Notification Email is used to send email alert to support team after 15 minutes when the workflow is triggered.</description>
        <protected>false</protected>
        <recipients>
            <field>Notification_Email_Id__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_TH_Exception_Notification_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEC_Update_Status</fullName>
        <field>TH1__Status__c</field>
        <formula>&apos;Approved&apos;</formula>
        <name>CEC Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CEC TH Email Generation Issue Notification</fullName>
        <active>true</active>
        <formula>IF((TH1__Document_Setting__r.TH1__Thunderhead_channel_name__c = &apos;Web&apos; || TH1__Document_Setting__r.TH1__Thunderhead_channel_name__c =&apos;HTML&apos; || TH1__Document_Setting__r.TH1__Thunderhead_channel_name__c =&apos;HTML Email&apos;) &amp;&amp;  TH1__Status__c  = &apos;Approved&apos; &amp;&amp;  NOT(ISBLANK(Notification_Email_Id__c)), True, False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CEC_TH_Exception_Notification_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>TH1__Draft__c.Trigger_Time_15__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
