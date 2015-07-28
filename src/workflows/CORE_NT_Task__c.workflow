<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CoreNT_Task_Completion_Notification_Email_Alert</fullName>
        <description>CoreNT Task Completion Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_On_Completion</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Critical</fullName>
        <description>CoreNT Task Escalation 1 week Post Task Due Date Email Alert (Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L1_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Critical1</fullName>
        <description>CoreNT Task Escalation 1 week Post Task Due Date Email Alert (Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L1_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Critical_New</fullName>
        <description>CoreNT Task Escalation 1 week Post Task Due Date Email Alert (Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L1_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Criticalnew</fullName>
        <description>CoreNT Task Escalation 1 week Post Task Due Date Email Alert (Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L1_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_3_week_Post_Task_Due_Date_Email_Alert_Critical</fullName>
        <description>CoreNT Task Escalation 3 week Post Task Due Date Email Alert(Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L2_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_3_week_Post_Task_Due_Date_Email_Alert_Critical_new</fullName>
        <description>CoreNT Task Escalation 3 week Post Task Due Date Email Alert(Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L2_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_1_Week_Post_Task_Due_Date_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Escalation_on_Due_Date_Email_Alert_Critical</fullName>
        <description>CoreNT Task Escalation on Due Date Email Alert (Critical)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Escalation_on_Due_Date_Email_Alert</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Notification_On_Start_Date_Email_Alert</fullName>
        <description>CoreNT Task Notification On Start Date Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_On_Start_Date</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Notification_Reminder_1_Week_Before_Task_Due_Date_Email_Alert_to_the</fullName>
        <description>CoreNT Task Notification Reminder 1 Week Before Task Due Date Email Alert to the Assigned User and Network Owner.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Reminder_1_Week_Before_Due_Date</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Notification_Reminder_Email_Alert_On_Due_Date</fullName>
        <description>CoreNT Task Notification Reminder Email Alert On Due Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Reminder_Email_Of_Due_Date</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Reminder_1_week_post_Task_Due_Date_Email_Alert_Non_Critical</fullName>
        <description>CoreNT Task Reminder 1 week post Task Due Date Email Alert (Non-Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L1_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Reminder_1_week_post_Task_Due_Date_Non_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Reminder_3_week_Post_Task_Due_Date_Email_Alert_Non_Critical</fullName>
        <description>CoreNT Task Reminder 3 week Post Task Due Date Email Alert (Non-Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L2_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Reminder_1_week_post_Task_Due_Date_Non_Critical</template>
    </alerts>
    <alerts>
        <fullName>CoreNT_Task_Reminder_3_week_Post_Task_Due_Date_Email_Alert_Non_Critical_New</fullName>
        <description>CoreNT Task Reminder 3 week Post Task Due Date Email Alert (Non-Critical)</description>
        <protected>false</protected>
        <recipients>
            <field>L2_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Network_Tracking/CoreNT_Task_Notification_Reminder_1_week_post_Task_Due_Date_Non_Critical</template>
    </alerts>
    <fieldUpdates>
        <fullName>L1_Manager_Field_Update</fullName>
        <field>L1_Manager_Email__c</field>
        <formula>Assigned_To__r.Manager.Email</formula>
        <name>L1 Manager Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_Manager_Field_Update</fullName>
        <field>L2_Manager_Email__c</field>
        <formula>Assigned_To__r.Manager.Manager.Email</formula>
        <name>L2 Manager Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CoreNT Task Escalation 1 week Post Task Due Date - Critical Tasks</fullName>
        <active>true</active>
        <description>Task Escalation 1 week Post Task Due Date (Critical) to Assigned User and Network Owner</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Critical</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L1_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Escalation 2 Week Post Task Due Date - Critical Tasks</fullName>
        <active>true</active>
        <description>Task Escalation 2 week Post Task Due Date (Critical)</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_3_week_Post_Task_Due_Date_Email_Alert_Critical</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L2_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Escalate Alert On Due Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CORE_NT_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>CORE_NT_Task__c.Critical__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Task Escalation Alert to the Network Owner and Assigned User on Due Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_on_Due_Date_Email_Alert_Critical</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Escalation 3 Week Post Task Due Date %28Critical%29</fullName>
        <active>false</active>
        <description>Task Escalation 3 week Post Task Due Date (Critical)</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_3_week_Post_Task_Due_Date_Email_Alert_Critical</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L2_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Escalation 3 Week Post Task Due Date %28Critical%29New</fullName>
        <active>false</active>
        <description>Task Escalation 3 week Post Task Due Date (Critical)</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_3_week_Post_Task_Due_Date_Email_Alert_Critical_new</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L2_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification On Completion</fullName>
        <actions>
            <name>CoreNT_Task_Completion_Notification_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CORE_NT_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This Workflow Rule is triggered on Task Completion which generates an Email notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification On Start Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CORE_NT_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This Workflow rule is triggered on the Start Date of the Task which sends out an email notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Notification_On_Start_Date_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Reminder 1 Week Before Task Due Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CORE_NT_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Task Reminder Alert Email 1 Week Before Task Due Date to Assigned User and Network Owner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Notification_Reminder_1_Week_Before_Task_Due_Date_Email_Alert_to_the</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Reminder 1 Week post Task Due Date %28Non-Critical%29</fullName>
        <active>false</active>
        <description>Task Escalation 1 week Post Task Due Date (Non-Critical) to Assigned User and Network Owner</description>
        <formula>AND((Complete__c ==false),(Critical__c ==false),(Due_Date__c &lt; TODAY()))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Reminder_1_week_post_Task_Due_Date_Email_Alert_Non_Critical</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Reminder 3 week Post Task Due Date %28Non-Critical%29</fullName>
        <active>false</active>
        <description>Task Reminder 3 week Post Task Due Date (Non-Critical)</description>
        <formula>AND((Complete__c ==false),(Critical__c ==false))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Reminder_3_week_Post_Task_Due_Date_Email_Alert_Non_Critical</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L2_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Reminder 3 week Post Task Due Date %28Non-Critical%29 New</fullName>
        <active>false</active>
        <description>Task Reminder 3 week Post Task Due Date (Non-Critical)</description>
        <formula>AND((Complete__c ==false),(Critical__c ==false))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Reminder_3_week_Post_Task_Due_Date_Email_Alert_Non_Critical_New</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L2_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task Notification Reminder Alert On Due Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CORE_NT_Task__c.Complete__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>CORE_NT_Task__c.Critical__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Task Reminder Alert to the Network Owner and Assigned User on Due Date,</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Notification_Reminder_Email_Alert_On_Due_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task notification Escalation 1 week Post Task Due Date %28Critical%29</fullName>
        <active>false</active>
        <description>Task Escalation 1 week Post Task Due Date (Critical) to Assigned User and Network Owner</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Critical1</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L1_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CoreNT Task notification Escalation 1 week Post Task Due Date %28Critical%29 New</fullName>
        <active>false</active>
        <description>Task Escalation 1 week Post Task Due Date (Critical) to Assigned User and Network Owner</description>
        <formula>AND((Complete__c ==false),(Critical__c ==true))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CoreNT_Task_Escalation_1_week_Post_Task_Due_Date_Email_Alert_Criticalnew</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>L1_Manager_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CORE_NT_Task__c.Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
