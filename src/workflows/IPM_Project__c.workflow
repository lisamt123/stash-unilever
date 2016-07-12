<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
   <alerts>
        <fullName>IPM_BET_EA_Archived</fullName>
        <description>IPM BET Linked BET Archived</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_BET_ET_Archived</template>
    </alerts>
    <alerts>
        <fullName>IPM_BET_EA_LinkDenied</fullName>
        <description>IPM_BET_EA_LinkDenied</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_BET_ET_LinkDenied</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_Finance_Leader_the_TLD_changed</fullName>
        <description>IPM Notify Finance Leader the TLD changed</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Finance_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Workflow_Emails/IPM_Notify_Finance_Leader_about_TLD_is_changed</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_PL_DPL_and_Gatekeeper_TLD_changed_after_Contract</fullName>
        <description>IPM Notify PL,DPL and Gatekeeper TLD changed after Contract</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Gatekeeper__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_PL_DPL_and_Gatekeeper_TLD_changed_after_Contract</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_PL_and_DPL_the_TLD_changed_during_Charter_or_Contract</fullName>
        <description>IPM Notify PL and DPL the TLD changed during Charter or Contract</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_PL_and_DPL_the_TLD_changed_during_Charter_or_Contract</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_Project_Leader_for_FL_TLD_confirmation</fullName>
        <description>IPM Notify Project Leader for FL TLD confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_Project_Leader_about_FL_confirm_TLD_change_on_Local_Rollout</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_leaders_the_TLD_changed_after_Contract</fullName>
        <description>IPM Notify leaders the TLD changed after Contract</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Finance_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Gatekeeper__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_PL_DPL_FL_and_Gatekeeper_TLD_changed_after_Contract</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_leaders_the_TLD_changed_during_Charter_Contract</fullName>
        <description>IPM Notify leaders the TLD changed during Charter or Contract</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Finance_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_PL_DPL_and_FL_TLD_is_changed</template>
    </alerts>
    <alerts>
        <fullName>IPM_Notify_the_Local_Project_leader_when_local_project_created</fullName>
        <description>IPM Notify the Local Project leader when local project created</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Notify_Local_Leader_when_local_project_created</template>
    </alerts>
    <alerts>
        <fullName>IPM_Project_Archival_Email_Alert</fullName>
        <description>IPM Project Archival Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Project_Archival_Mail_Alert</template>
    </alerts>
    <alerts>
        <fullName>IPM_Send_Failure_Phase_Change_Notification</fullName>
        <description>Send Failure Phase Change Notification</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_FailurePhaseChangeTemplate</template>
    </alerts>
    <alerts>
        <fullName>IPM_Send_Success_Phase_Change_Notification</fullName>
        <description>Send Success Phase Change Notification</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_Successful_Phase_Change_Template</template>
    </alerts>
    <alerts>
        <fullName>IPM_Send_email_to_PL_DPL_TPL_and_Gatekeeper_when_project_stopped</fullName>
        <description>IPM Send email to PL,DPL,TPL and Gatekeeper when project stopped</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Gatekeeper__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Technical_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_team_members_when_project_stopped</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_to_PL_DPL_TPL_and_Gatekeeper_when_project_reactivated</fullName>
        <description>IPM send email to PL,DPL,TPL and Gatekeeper when project reactivated</description>
        <protected>false</protected>
        <recipients>
            <field>Deputy_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Gatekeeper__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>IPM_Technical_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_send_email_when_project_reactivated</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_to_RPL_and_BBPL_when_Global_project_stopped</fullName>
        <description>IPM send email to RPL and BBPL when Global project stopped</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_RPL_and_BBPL_when_Global_project_stopped</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_to_RPL_when_local_project_is_ready_for_archival_from_rollout_plan</fullName>
        <description>IPM send email to RPL when local project is ready for archival from rollout plan</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Stopped_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_RPL_when_local_project_is_ready_for_archival_from_rollout_plan</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_when_current_project_is_stopped</fullName>
        <description>IPM send email when current project is stopped</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_when_current_project_is_stopped</template>
    </alerts>
    <alerts>
        <fullName>IPM_send_email_when_current_project_is_stopped_in_ideas_phase</fullName>
        <description>IPM send email when current project is stopped in ideas phase</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_when_current_project_is_stopped_in_ideas_phase</template>
    </alerts>
    <alerts>
        <fullName>Notify_BBPL_When_Regional_PL_initiates_Archival</fullName>
        <description>Notify BBPL When Regional PL initiates Archival</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_Leader__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_BBPL_when_Regional_PL_initiates_Archival</template>
    </alerts>
    <alerts>
        <fullName>Notify_RPL_When_local_PL_Unarchives_Local_Project</fullName>
        <description>Notify RPL When local PL Unarchives Local Project</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_PreviouslyStoppedBy__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_send_email_to_RPL_when_local_project_is_marked_unarchived</template>
    </alerts>
    <fieldUpdates>
        <fullName>Bosscard_Status</fullName>
        <field>IPM_Bosscard_Status__c</field>
        <literalValue>1</literalValue>
        <name>Bosscard Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FD_BET_First_Release_Date_Due_Part_1</fullName>
        <field>BET_First_Release_Previous_Value__c</field>
        <formula>PRIORVALUE( BET_MS_First_Release_Date__c )</formula>
        <name>FD BET First Release Date Due Part 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Archive_Project</fullName>
        <description>Archive Project arter 4 Months</description>
        <field>Is_Archieved__c</field>
        <literalValue>1</literalValue>
        <name>IPM Archive Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_BET_FU_Ready_to_Update_BET</fullName>
        <field>BET_Update__c</field>
        <literalValue>1</literalValue>
        <name>IPM BET FU Ready to Update BET</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Batch_Initiate</fullName>
        <field>IPM_Batch_Initiate__c</field>
        <literalValue>1</literalValue>
        <name>IPM Batch Initiate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_CorepUpdate</fullName>
        <field>IPM_IsCompleted__c</field>
        <literalValue>1</literalValue>
        <name>IPM_CorepUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Project_Stopped_By</fullName>
        <field>IPM_Project_Stopped_By__c</field>
        <formula>LastModifiedBy.FirstName  &amp; &apos; &apos;  &amp;  LastModifiedBy.LastName</formula>
        <name>IPM Project Stopped By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Project_Stopped_Date_Time_FieldUpdat</fullName>
        <field>IPM_Stopped_Date_Time__c</field>
        <formula>LastModifiedDate</formula>
        <name>IPM Project Stopped Date/Time FieldUpdat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Global_Project_Id</fullName>
        <description>To populate global project Id</description>
        <field>IPM_Global_ProjectId__c</field>
        <formula>IPM_Global_Project_Id__c</formula>
        <name>IPM Update Global Project Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phase</fullName>
        <field>IPM_Phase__c</field>
        <literalValue>Feasibility</literalValue>
        <name>Phase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Threshold_Value</fullName>
        <field>IPM_Threshold_Value__c</field>
        <literalValue>Yes</literalValue>
        <name>Threshold Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update</fullName>
        <field>ManualCheck__c</field>
        <literalValue>1</literalValue>
        <name>Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BET_First_Release_Chatter_Post</fullName>
        <field>BET_First_Release_Chatter_Post__c</field>
        <formula>&apos;BET First Release Due&apos;</formula>
        <name>Update BET First Release Chatter Post</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_FL_Confirm_button_on_Project</fullName>
        <field>MisAligned_Confirmed_By_Finance_Leader__c</field>
        <literalValue>0</literalValue>
        <name>Update FL Confirm button on Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IPM_Project_Name</fullName>
        <field>Name</field>
        <formula>IPM_Project_Name__c</formula>
        <name>Update IPM Project Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Project_As_Archieved</fullName>
        <field>Is_Archieved__c</field>
        <literalValue>1</literalValue>
        <name>Update Project As Archieved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rollout_TLD_on_Project</fullName>
        <description>Update Rollout TLD on Project</description>
        <field>Rollout_Plan_Target_Launch_Date__c</field>
        <formula>IPM_Target_Launch_Dates__c</formula>
        <name>Update Rollout TLD on Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Threshold_Value</fullName>
        <field>IPM_Threshold_Value__c</field>
        <literalValue>No</literalValue>
        <name>Update Threshold Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_field_Previous_Target_Launch_Date</fullName>
        <field>Previous_Target_Launch_Date__c</field>
        <formula>PRIORVALUE(IPM_Target_Launch_Dates__c)</formula>
        <name>Update field Previous_Target_Launch_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_phase</fullName>
        <field>IPM_Phase__c</field>
        <literalValue>Ideas</literalValue>
        <name>update phase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BET First Release Date Due</fullName>
        <active>true</active>
        <formula>BET_First_Release_Previous_Value__c  &lt;&gt;  BET_MS_First_Release_Date__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_BET_First_Release_Chatter_Post</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.BET_MS_First_Release_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BET First Release Date Due Part 1</fullName>
        <actions>
            <name>FD_BET_First_Release_Date_Due_Part_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISCHANGED( BET_MS_First_Release_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Bosscard Status</fullName>
        <actions>
            <name>Bosscard_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>(ISPICKVAL( IPM_Bosscard__r.IPM_Bosscard_Status__c,&apos;Approved&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Failed Project Phase Change</fullName>
        <actions>
            <name>IPM_Send_Failure_Phase_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(IPM_Project_Job_Status__c,&apos;Failed&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Global Project Populate</fullName>
        <actions>
            <name>IPM_Update_Global_Project_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Global_Project_Id__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>Populate Global Project Id</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Project Archival On Inactive</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.Is_Archieved__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Last_Modified_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Project_Name__c</field>
            <operation>notEqual</operation>
            <value>IPM_MasterProject</value>
        </criteriaItems>
        <description>Archive a Project if Inactive for More than 4 Weeks. Based on Last Modified Date REQ00378</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Archive_Project</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.LastModifiedDate</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Project_Archival_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IPM_Project__c.LastModifiedDate</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IPM Project Name Updation</fullName>
        <actions>
            <name>Update_IPM_Project_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Project_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update IPM Project Name</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Project Stopped Date%2FTime</fullName>
        <actions>
            <name>IPM_Project_Stopped_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IPM_Project_Stopped_Date_Time_FieldUpdat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.Is_Archieved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Send Email to Project Leader Once FL ackldge TLD change</fullName>
        <actions>
            <name>IPM_Notify_Project_Leader_for_FL_TLD_confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>IPM Send Email to Project Leader Once Finance Leader acknowledge  TLD change on Financial page</description>
        <formula>AND(ISCHANGED( MisAligned_Confirmed_By_Finance_Leader__c),  MisAligned_Confirmed_By_Finance_Leader__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Update Project Phase Based on RCLT GKM</fullName>
        <active>false</active>
        <description>To update the phase of the Global project based on the Regional Project</description>
        <formula>IF(AND(NOT(ISNULL(IPM_Parent_Project__c)),ISPICKVAL(IPMProject_Span__c, &apos;Regional&apos;),ISPICKVAL(IPM_Project_Type__c, &apos;Rollout&apos;)), True, False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Update Project Phase Based on RCLT Model</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Project_Type__c</field>
            <operation>equals</operation>
            <value>Rollout</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project__c.IPMProject_Span__c</field>
            <operation>equals</operation>
            <value>Regional</value>
        </criteriaItems>
        <description>To update the phase of the Global project based on the Regional Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM_BET_WF_Archived</fullName>
        <actions>
            <name>IPM_BET_EA_Archived</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISNULL(BET_Archived_BET_Text__c)), ISCHANGED(BET_Archived_BET_Text__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM_BET_WF_AutoApproveBETlink</fullName>
        <active>true</active>
        <description>time based workflow to update the BET link after 72 hours on the project</description>
        <formula>!ISNULL(BET_Link_Requested__c) &amp;&amp; !ISBLANK(BET_Link_Requested__c) &amp;&amp; NOT( ISPICKVAL( IPM_Phase__c , &apos;Ideas&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_BET_FU_Ready_to_Update_BET</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.BET_Link_Requested_on_Date__c</offsetFromField>
            <timeLength>72</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IPM_BET_WF_LinkDenied</fullName>
        <actions>
            <name>IPM_BET_EA_LinkDenied</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(NOT(ISNULL(BET_Denied_BET_Link__c)) ,ISCHANGED(BET_Denied_BET_Link__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM_CoreparameterComplete</fullName>
        <actions>
            <name>IPM_CorepUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Or((And(IPM_Answer_of_Q1__c!=null, IPM_Answer_of_Q2__c!=null, IPM_Answer_of_Q3__c!=null,text( IPM_ProjectSubType__c )==&apos;Innovation/Renovation&apos; )),(And(IPM_Answer_of_Q1__c!=null, IPM_Answer_of_Q2__c!=null,  text( IPM_ProjectSubType__c )  ==&apos;Brand Led Growth(BLG)&apos;)),(And(IPM_Answer_of_Q1__c!=null, IPM_Answer_of_Q3__c!=null,text( IPM_ProjectSubType__c ) ==&apos;Operational&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification to LFL for TLD change in Local Rollout Project</fullName>
        <actions>
            <name>IPM_Notify_Finance_Leader_the_TLD_changed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notification to Finance Leader for TLD change in Local Rollout Project</description>
        <formula>AND( ISPICKVAL(IPMProject_Span__c, &apos;Local&apos;),  ISPICKVAL(IPM_Project_Type__c, &apos;Rollout&apos;),
OR(ISPICKVAL(IPM_Phase__c, &apos;Feasibility&apos;),
ISPICKVAL(IPM_Phase__c, &apos;Capability&apos;),
ISPICKVAL(IPM_Phase__c, &apos;Market Ready&apos;),
ISPICKVAL(IPM_Phase__c, &apos;Market Deployment&apos;)), ISCHANGED( IPM_Target_Launch_Dates__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Stop Project After 72 Hours</fullName>
        <active>true</active>
        <formula>AND(IPM_PrepareForArchival__c,IPM_StoppedByProject__c == NULL)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Project_As_Archieved</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.IPM_CancelStoppingProjectTill__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Successful Project Phase</fullName>
        <actions>
            <name>IPM_Send_Success_Phase_Change_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISPICKVAL(IPM_ProjectJobType__c,&apos;Phase Change&apos;),ISPICKVAL(IPM_Project_Job_Status__c,&apos;Completed&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Test work flow12</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.IPMProject_Span__c</field>
            <operation>equals</operation>
            <value>Regional</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Project__c.IPM_Phase__c</field>
            <operation>equals</operation>
            <value>Feasibility</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Project__c.IPM_Trigger_Time_05__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Threshold Value</fullName>
        <actions>
            <name>Threshold_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.Exempt_from_Threshold__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Threshold Value Update</fullName>
        <actions>
            <name>Update_Threshold_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project__c.Exempt_from_Threshold__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Finance Leader Confirm button on Project</fullName>
        <actions>
            <name>Update_FL_Confirm_button_on_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Finance Leader Confirm button on Project</description>
        <formula>AND(!ISBLANK( Rollout_Plan_Target_Launch_Date__c ), ISCHANGED(  IPM_Target_Launch_Dates__c  ), (IPM_Target_Launch_Dates__c != Rollout_Plan_Target_Launch_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Rollout Plan TLD on IPM Project</fullName>
        <actions>
            <name>Update_Rollout_TLD_on_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Project__c.Rollout_Plan_Target_Launch_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Update Rollout Plan TLD on IPM Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update field on change of ms release field</fullName>
        <active>false</active>
        <formula>ISCHANGED( BET_MS_First_Release_Date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the previous TLD value</fullName>
        <actions>
            <name>Update_field_Previous_Target_Launch_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Update the previous TLD value in Previous_Target_Launch_Date__c field</description>
        <formula>ISCHANGED(IPM_Target_Launch_Dates__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
