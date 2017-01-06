<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Risk_Assesment_Email</fullName>
        <description>Risk Assesment Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAFE_Emails/SAFE_Risk_Assessment_Status</template>
    </alerts>
    <alerts>
        <fullName>Send_an_alert_if_the_status_is_completed_but_no_solution_is_tagged</fullName>
        <description>Send an alert if the status is completed but no solution is tagged</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAFE_Emails/SAFE_Risk_Assessment_Status</template>
    </alerts>
    <alerts>
        <fullName>This_work_flow_will_send_and_email_alert_message_to_the_PM_user_when_the_Risk_As</fullName>
        <description>This work flow will send and email alert message to the PM user when the Risk Assessment record is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAFE_PMGroup</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAFE_Emails/SAFE_Risk_Assessment_Template</template>
    </alerts>
    <rules>
        <fullName>SAFE Risk Assessment</fullName>
        <actions>
            <name>This_work_flow_will_send_and_email_alert_message_to_the_PM_user_when_the_Risk_As</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAFE_Risk_Assessment__c.SAFE_Status__c</field>
            <operation>equals</operation>
            <value>Not Completed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAFE Risk Assessment Status Completed</fullName>
        <actions>
            <name>Send_an_alert_if_the_status_is_completed_but_no_solution_is_tagged</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL( SAFE_Status__c , &apos;Completed&apos;), ISBLANK(  SAFE_Solution_Name__c ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAFE_RiskAssesmentEmailRule</fullName>
        <actions>
            <name>Risk_Assesment_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAFE_Risk_Assessment__c.SAFE_Status__c</field>
            <operation>equals</operation>
            <value>Not Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>SAFE_Risk_Assessment__c.SAFE_Project_End_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
