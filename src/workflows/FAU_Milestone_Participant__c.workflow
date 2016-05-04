<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FAU_Send_1st_Reminder_Email</fullName>
        <description>FAU Send 1st Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Participant_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Milestone_Reminder</template>
    </alerts>
    <alerts>
        <fullName>FAU_Send_2nd_Reminder_Email</fullName>
        <description>FAU Send 2nd Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Participant_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Milestone_Reminder</template>
    </alerts>
    <alerts>
        <fullName>FAU_Send_Due_Date_Reminder_Email</fullName>
        <description>FAU Send Due Date Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Participant_s_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Milestone_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>FAU_Send_1st_Reminder_Email</fullName>
        <description>FAU Send 1st Reminder Email</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Send 1st Reminder Email&quot;</formula>
        <name>FAU Send 1st Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Send_2nd_Reminder_Email</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Send 2nd Reminder Email&quot;</formula>
        <name>FAU Send 2nd Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Send_Due_Date_Reminder_Email</fullName>
        <description>FAU Send Due Date Reminder Email</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Send Due Date Reminder Email&quot;</formula>
        <name>FAU Send Due Date Reminder Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>FAU_Participant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Milestone_Participant_Email</fullName>
        <description>Update Participant&apos;s Milestone Email</description>
        <field>FAU_Participant_s_Email__c</field>
        <formula>FAU_Participant__r.FAU_Email_Address__c</formula>
        <name>FAU_Update_Milestone_Participant_Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FAU Milestone 1st Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_1st_Reminder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Participant_s_Invite_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <description>EMAIL: This sends a Milestones Participant 1st Reminder.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Send_1st_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Send_1st_Reminder_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Milestone_Participant__c.FAU_Workflow_1st_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Milestone 2nd Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_2nd_Reminder__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Participant_s_Invite_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <description>EMAIL: This sends a Milestones Participant 1st Reminder.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Send_2nd_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Send_2nd_Reminder_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Milestone_Participant__c.FAU_Workflow_2nd_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Milestone Due Date Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Due_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Status__c</field>
            <operation>notEqual</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Milestone_Participant__c.FAU_Participant_s_Invite_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <description>EMAIL: This sends a Milestones Participant Due Date Reminder.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Send_Due_Date_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Send_Due_Date_Reminder_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Milestone_Participant__c.FAU_Workflow_Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU_Update_Milestone_Participant_Email</fullName>
        <actions>
            <name>FAU_Update_Milestone_Participant_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FIELD UPDATES: Update Milestone Participant Email.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
