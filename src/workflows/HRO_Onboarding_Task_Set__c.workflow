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
    <alerts>
        <fullName>Pre_Boarding_welcome_email_to_Manager</fullName>
        <description>Pre-Boarding welcome email to Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Pre_Boarding_welcome_email</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Beyond</fullName>
        <description>Upcoming tasks Beyond Onboarding</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Beyond</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Day1</fullName>
        <description>Upcoming tasks Day 1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Day1</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Month1</fullName>
        <description>Upcoming tasks Month 1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Month1</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Month2</fullName>
        <description>Upcoming tasks Month 2</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Month2</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Month3</fullName>
        <description>Upcoming tasks Month 3</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Month3</template>
    </alerts>
    <alerts>
        <fullName>Upcoming_tasks_Week1</fullName>
        <description>Upcoming tasks Week 1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>HRO_Onboarding/HRO_Proactive_notification_Week1</template>
    </alerts>
    <rules>
        <fullName>HRO Overdue task notifications</fullName>
        <active>true</active>
        <description>Notifications: Overdue task notifications</description>
        <formula>NOT(ISBLANK(Overdue_Notification_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>HRO_Overdue_task_notifications</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Overdue_Notification_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>HRO Proactive notification of upcoming tasks</fullName>
        <actions>
            <name>Pre_Boarding_welcome_email_to_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>HRO_Onboarding_Task_Set__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Proactive notification of upcoming tasks</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Week1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Month2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Month3</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>56</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Day1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Month1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Upcoming_tasks_Beyond</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>HRO_Onboarding_Task_Set__c.Start_Date__c</offsetFromField>
            <timeLength>84</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sent Email Notifications</fullName>
        <active>false</active>
        <criteriaItems>
            <field>HRO_Onboarding_Task_Set__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Workflow sent email notifications basing on</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
