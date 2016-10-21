<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FAU_Biography_Details_Request</fullName>
        <description>FAU Biography Details Request</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Fill_Biography_Invitation</template>
    </alerts>
    <alerts>
        <fullName>FAU_Part_Bio_Fill_Invitation</fullName>
        <description>FAU Bio Fill Invitation</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Fill_Biography_Invitation</template>
    </alerts>
    <alerts>
        <fullName>FAU_Program_Invitation</fullName>
        <description>FAU Program Invitation</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_eXcel_rator_Invitation</template>
    </alerts>
    <alerts>
        <fullName>FAU_Program_Invitation_Reminder</fullName>
        <description>FAU Program Invitation - Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_eXcel_rator_Invitation_Reminder</template>
    </alerts>
    <alerts>
        <fullName>FAU_Program_Invitation_to_PA</fullName>
        <description>FAU Program Invitation to PA</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Personal_Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_PA_eXcel_rator_Invitation</template>
    </alerts>
    <alerts>
        <fullName>FAU_Program_Invitation_to_PA_Reminder</fullName>
        <description>FAU Program Invitation to PA - Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Personal_Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_eXcel_rator_Invitation_Reminder</template>
    </alerts>
    <alerts>
        <fullName>FAU_Send_Email_to_Administrator_Create_Upgrade_User</fullName>
        <description>FAU Send Email to Administrator Create/Upgrade User</description>
        <protected>false</protected>
        <recipients>
            <recipient>suryanarayanan.ramachandran@unilever.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_Request_New_Upgrade_Personal_Assistant_User</template>
    </alerts>
    <alerts>
        <fullName>FAU_Send_Introduction_to_PA</fullName>
        <description>FAU Send Introduction to PA</description>
        <protected>false</protected>
        <recipients>
            <field>FAU_Personal_Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FAU_Program_Protected/FAU_PA_Introduction</template>
    </alerts>
    <fieldUpdates>
        <fullName>FAU_Program_Invitation</fullName>
        <description>FAU Program Invitation</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Program Invitation&quot;</formula>
        <name>FAU Program Invitation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Program_Invitation_to_PA</fullName>
        <description>FAU Program Invitation to PA</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Program Invitation to PA&quot;</formula>
        <name>FAU Program Invitation to PA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Program_Invitation_to_PA_Reminder_1</fullName>
        <description>FAU Program Invitation to PA - Reminder</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Program Invitation to PA - Reminder 1&quot;</formula>
        <name>FAU Program Invitation to PA Reminder  1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Program_Invitation_to_PA_Reminder_2</fullName>
        <description>FAU Program Invitation to PA - Reminder 2</description>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Program Invitation to PA - Reminder 2&quot;</formula>
        <name>FAU Program Invitation to PA Reminder 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_BIo_to_Complete</fullName>
        <field>FAU_Bio_Completeness_Flag__c</field>
        <literalValue>1</literalValue>
        <name>FAU Update BIo to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Address</fullName>
        <field>FAU_Email_Address__c</field>
        <formula>FAU_User__r.Email</formula>
        <name>FAU Update Email Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Bio_Due_Date</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Biography Details Request - Due Date&quot;</formula>
        <name>FAU Update Email Bio Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Bio_Request_1</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Biography Details Request - Reminder 1&quot;</formula>
        <name>FAU Update Email Bio Request 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Bio_Request_2</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;FAU Biography Details Request - Reminder 2&quot;</formula>
        <name>FAU Update Email Bio Request 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Invite_Participant_1</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;Send Initial Program invitation to participant 1st&quot;</formula>
        <name>FAU Update Email Invite Participant 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Email_Invite_Participant_2</fullName>
        <field>FAU_Last_Email_Sent__c</field>
        <formula>&quot;Send Initial Program invitation to participant 2nd&quot;</formula>
        <name>FAU Update Email Invite Participant 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_External_ID</fullName>
        <field>FAU_External_ID__c</field>
        <formula>FAU_Program_Wave__r.FAU_Program_Number__c + &apos;:&apos; +   FAU_User__r.Email</formula>
        <name>FAU Update External ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_First_Name</fullName>
        <description>Update First Name from User</description>
        <field>FAU_First_Name__c</field>
        <formula>FAU_User__r.FirstName</formula>
        <name>FAU Update First Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Job_Title</fullName>
        <field>FAU_Job_Title__c</field>
        <formula>FAU_User__r.Title</formula>
        <name>FAU Update Job Title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Last_Name</fullName>
        <field>FAU_Last_Name__c</field>
        <formula>FAU_User__r.LastName</formula>
        <name>FAU Update Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Mobile</fullName>
        <field>FAU_Mobile_Number__c</field>
        <formula>FAU_User__r.MobilePhone</formula>
        <name>FAU Update Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Unique_ID</fullName>
        <field>FAU_Unique_ID__c</field>
        <formula>FAU_Program_Wave__r.Id + &apos;:&apos; + FAU_User__r.Id</formula>
        <name>FAU Update Unique ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BIo_to_not_Complete</fullName>
        <field>FAU_Bio_Completeness_Flag__c</field>
        <literalValue>0</literalValue>
        <name>FAU Update BIo to not Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU Email %3AUser Changes Participant Details</fullName>
        <active>true</active>
        <description>FAU Email : Send Email to  Program Administrator about User Changing Participant Details</description>
        <formula>NOT(ISCHANGED( FAU_Invite_State__c )) &amp;&amp;  ($User.Id  =  FAU_User__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Prefill Personal Details</fullName>
        <actions>
            <name>FAU_Update_Email_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_First_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_Job_Title</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FAU_Update_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_User__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>FIELD UPDATES:: Pre-fill Personal Details when the user is identified</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FAU Send Biography  Fill EM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Bio_Completeness_Flag__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Invite_State__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <description>EMAIL: Send Emails to have the Participant Fill the Biography</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Biography_Details_Request</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Update_Email_Bio_Due_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_Biography_Deadline__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Biography_Details_Request</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Update_Email_Bio_Request_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_Biography_Deadline__c</offsetFromField>
            <timeLength>-21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Biography_Details_Request</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Update_Email_Bio_Request_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_Biography_Deadline__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Send Introduction to PA</fullName>
        <actions>
            <name>FAU_Send_Introduction_to_PA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>EMAIL: Send Introduction to participant PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FAU Send Invite</fullName>
        <actions>
            <name>FAU_Program_Invitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FAU_Program_Invitation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Invite_State__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>EMAIL: Send invitation to participant</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FAU Send Invite to PA</fullName>
        <actions>
            <name>FAU_Program_Invitation_to_PA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>FAU_Program_Invitation_to_PA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Invite_State__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>EMAIL: Send invitation to participant PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FAU Send PA Invite - Reminders</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Invite_State__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Program_Don_t_Send_Reminders__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>EMAIL: Send intial program invitation to participant&apos;s PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Program_Invitation_to_PA_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Program_Invitation_to_PA_Reminder_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_RSVP_Deadline__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Program_Invitation_to_PA_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Program_Invitation_to_PA_Reminder_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_RSVP_Deadline__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Send Program Invite - Reminders</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Invite_State__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Program_Don_t_Send_Reminders__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Participant__c.FAU_Is_deferred_To_PA__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>EMAIL: Send Initial Program invitation to participant</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Program_Invitation_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Update_Email_Invite_Participant_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_RSVP_Deadline__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Program_Invitation_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FAU_Update_Email_Invite_Participant_1</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Participant__c.FAU_RSVP_Deadline__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Update BIo to Complete</fullName>
        <actions>
            <name>FAU_Update_BIo_to_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATES: This updates the Bio Completeness Flag to True</description>
        <formula>IF((FAU_Biography__c &lt;&gt; NULL)&amp;&amp;  (FAU_Unilever_Career__c &lt;&gt; NULL)&amp;&amp;  (FAU_Prior_Career__c &lt;&gt; NULL) &amp;&amp;  (FAU_Education__c &lt;&gt; NULL) &amp;&amp;  (FAU_Personal__c &lt;&gt; NULL)  ,True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Update BIo to Complete to False</fullName>
        <actions>
            <name>Update_BIo_to_not_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATES: This updates the Bio Completeness Flag to False</description>
        <formula>IF((FAU_Biography__c = NULL)|| (FAU_Unilever_Career__c = NULL)||  (FAU_Prior_Career__c = NULL) || (FAU_Education__c = NULL) || (FAU_Personal__c = NULL)  ,True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU Update External ID</fullName>
        <actions>
            <name>FAU_Update_External_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATE: Update the External ID</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FAU_Create Unique ID</fullName>
        <actions>
            <name>FAU_Update_Unique_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>FIELD UPDATE FAU Create Unique ID - This is used to make sure a participant is only added once.</description>
        <formula>True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>FAU_Create_Personal_Assistant</fullName>
        <assignedTo>rangappa.a.gunda@unilever.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Can you create/upgrade the Personal Assistant User for this Participant using the email &apos;Request PA User Email Address&apos;. &amp;  Unilever - Force Multi Profile 

After you create the user, add the user to &apos;Personal Assistant&apos; field.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Personal Assistant</subject>
    </tasks>
</Workflow>
