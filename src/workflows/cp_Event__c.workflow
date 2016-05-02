<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Local_Approver_when_Proposed_dates_are_changed</fullName>
        <description>Notify Local Approver &amp; Project Lead when Proposed dates are changed</description>
        <protected>false</protected>
        <recipients>
            <field>Local_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/Notify_Approver_of_Date_Changes</template>
    </alerts>
    <alerts>
        <fullName>Notify_Project_Lead_Owner_that_Event_has_been_approved</fullName>
        <description>Notify Project Lead &amp; Owner that Event has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Project_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/Notify_Project_Lead_approval_was_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_Project_Lead_Owner_that_Event_has_been_rejected</fullName>
        <description>Notify Project Lead &amp; Owner that Event has been rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Project_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/Notify_Project_Lead_approval_was_Declined</template>
    </alerts>
    <alerts>
        <fullName>Recalled_Event</fullName>
        <description>Recalled Event</description>
        <protected>false</protected>
        <recipients>
            <field>Local_Approver__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Emails/Notify_Project_Lead_Approver_Event_was_RECALLED</template>
    </alerts>
    <fieldUpdates>
        <fullName>Global_Client_Set_to_TRUE</fullName>
        <field>Global_Events__c</field>
        <literalValue>1</literalValue>
        <name>Global Client? Set to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Local_Client_Set_to_FALSE</fullName>
        <field>Global_Events__c</field>
        <literalValue>0</literalValue>
        <name>Local Client? Set to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Status_to_Confirmed</fullName>
        <description>Activity Status will be set to Confirmed, and will appear in the Planner/POAP as a solid colour</description>
        <field>Activity_Status__c</field>
        <literalValue>Confirmed</literalValue>
        <name>Set Activity Status to Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Status_to_Draft</fullName>
        <description>Updating from Offline to Draft
Draft Statuses will appear on the Planner &amp; POAP as Grey</description>
        <field>Activity_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Activity Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Status_to_Offline</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Offline</literalValue>
        <name>Set Activity Status to Offline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Activity_Status_to_Tentative</fullName>
        <description>Activity Status will be set to Tentative, and on the Planner/POAP will appear a borderlined box</description>
        <field>Activity_Status__c</field>
        <literalValue>Tentative</literalValue>
        <name>Set Activity Status to Tentative</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_History_to_FALSE</fullName>
        <field>Approval_History_Toggle__c</field>
        <literalValue>0</literalValue>
        <name>Set Approval History to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_History_to_TRUE</fullName>
        <field>Approval_History_Toggle__c</field>
        <literalValue>1</literalValue>
        <name>Set Approval History to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Re_Approval_False</fullName>
        <field>ReApprovalRequired__c</field>
        <literalValue>0</literalValue>
        <name>Set Re-Approval to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Re_Approval_True</fullName>
        <field>ReApprovalRequired__c</field>
        <literalValue>1</literalValue>
        <name>Set Re-Approval to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Recall_to_False</fullName>
        <field>Recalled__c</field>
        <literalValue>0</literalValue>
        <name>Set Recall to FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Recalled_to_TRUE</fullName>
        <field>Recalled__c</field>
        <literalValue>1</literalValue>
        <name>Set Recalled to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EventDraft</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EventApproved</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Offline</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EventDraft</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Offline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_to_Pending</fullName>
        <field>RecordTypeId</field>
        <lookupValue>EventPending</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Self_Reference</fullName>
        <field>Self_Reference__c</field>
        <formula>Id</formula>
        <name>Update Self Reference</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submission_Status</fullName>
        <field>Activity_Status__c</field>
        <literalValue>Offline</literalValue>
        <name>Update Submission Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Was_Approved_flag_to_TRUE</fullName>
        <field>Was_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update &apos;Was Approved&apos; flag to TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>A confirmed event is now tentative</fullName>
        <actions>
            <name>Set_Activity_Status_to_Tentative</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(  ISPICKVAL( Activity_Status__c, &quot;Confirmed&quot;) &amp;&amp;  ISPICKVAL(Are_Dates_Guarenteed__c, &quot;No&quot;)  ) &amp;&amp;  (ISPICKVAL( Local_or_Global__c, &quot;Local&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clone with Approval - Record Type</fullName>
        <actions>
            <name>Set_Activity_Status_to_Offline</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_Offline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>cp_Event__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Event Cloning</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.NeedReApproval__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clone without Approval - Record Type %28Confirmed%29</fullName>
        <actions>
            <name>Set_Activity_Status_to_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>cp_Event__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Event Cloning</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.NeedReApproval__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Are_Dates_Guarenteed__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Clone without Approval - Record Type %28Tentative%29</fullName>
        <actions>
            <name>Set_Activity_Status_to_Tentative</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>cp_Event__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Event Cloning</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.NeedReApproval__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Are_Dates_Guarenteed__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Event Dates modified</fullName>
        <actions>
            <name>Notify_Local_Approver_when_Proposed_dates_are_changed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Proposed Dates have been changed
&amp; Submission status is anything except offline.</description>
        <formula>(ISCHANGED ( StartDate__c ) || ISCHANGED ( EndDate__c )) &amp;&amp; NOT(ISPICKVAL( Activity_Status__c, &quot;Offline&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Global Event Selected</fullName>
        <actions>
            <name>Global_Client_Set_to_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Local_or_Global__c</field>
            <operation>equals</operation>
            <value>Global</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Global Re-Approval Process</fullName>
        <actions>
            <name>Set_Re_Approval_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Submission_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For approved Global events only, trigger re-approval if the following fields have changed: Start Date, End Date, Are date guaranteed?</description>
        <formula>ISPICKVAL(Local_or_Global__c ,&quot;Global&quot;) &amp;&amp; ( ISPICKVAL(Activity_Status__c,&quot;Confirmed&quot;)|| ISPICKVAL(Activity_Status__c,&quot;Tentative&quot;) )  &amp;&amp; ( (ISCHANGED(StartDate__c)||ISCHANGED(EndDate__c )|| ISCHANGED(Are_Dates_Guarenteed__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>If ByPass is selected %26 Dates are confirmed%3F</fullName>
        <actions>
            <name>Set_Activity_Status_to_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>cp_Event__c.Bypass_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Are_Dates_Guarenteed__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Local_or_Global__c</field>
            <operation>equals</operation>
            <value>Global</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>If ByPass is selected %26 Dates are unconfirmed%3F</fullName>
        <actions>
            <name>Set_Activity_Status_to_Tentative</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_to_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>cp_Event__c.Bypass_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Are_Dates_Guarenteed__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Local_or_Global__c</field>
            <operation>equals</operation>
            <value>Global</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Local Event Selected</fullName>
        <actions>
            <name>Local_Client_Set_to_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Local_or_Global__c</field>
            <operation>equals</operation>
            <value>Local</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Tentative Event has now become confirmed</fullName>
        <actions>
            <name>Set_Activity_Status_to_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>( ISPICKVAL( Activity_Status__c, &quot;Tentative&quot;) &amp;&amp;  ISPICKVAL(Are_Dates_Guarenteed__c, &quot;Yes&quot;) ) &amp;&amp;  (ISPICKVAL( Local_or_Global__c, &quot;Local&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Self Reference Id</fullName>
        <actions>
            <name>Update_Self_Reference</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Local_or_Global__c</field>
            <operation>equals</operation>
            <value>Global</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Workaround%3A Send Approved Email</fullName>
        <actions>
            <name>Notify_Project_Lead_Owner_that_Event_has_been_approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Approval_History_to_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Approval_History_Toggle__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Tentative,Confirmed</value>
        </criteriaItems>
        <description>Requires a workaround due to order of execution to get the &quot;Step Comments&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Workaround%3A Send Recalled Email</fullName>
        <actions>
            <name>Recalled_Event</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Approval_History_to_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Recall_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Approval_History_Toggle__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Offline</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Recalled__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Requires a workaround due to order of execution to get the &quot;Step Comments&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Workaround%3A Send Rejected Email</fullName>
        <actions>
            <name>Notify_Project_Lead_Owner_that_Event_has_been_rejected</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Approval_History_to_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>cp_Event__c.Approval_History_Toggle__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Activity_Status__c</field>
            <operation>equals</operation>
            <value>Offline</value>
        </criteriaItems>
        <criteriaItems>
            <field>cp_Event__c.Recalled__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Requires a workaround due to order of execution to get the &quot;Step Comments&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
