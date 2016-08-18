<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_request_email_template_to_Step3_approver</fullName>
        <description>&quot;Approval request email template&quot; to Step3 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>ramesh.suddapalli@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_1_approver</fullName>
        <ccEmails>ramesh.suddapalli@accenture.com</ccEmails>
        <description>&quot;Approval request email template&quot; to Step 1 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>jyotirmoy.sharma@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_2_approver</fullName>
        <description>&quot;Approval request email template&quot; to Step 2 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_AFM_Approvers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_approver_for_Final_Approve</fullName>
        <description>&quot;Approval request email template&quot; to approver for Final Approve</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Opportunity_Approved</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_approver_for_Final_Reject</fullName>
        <description>Approval request email template&quot; to approver for Final Reject</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Opportunity_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Opp_Owner</fullName>
        <description>Email Alert to Opp Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Email_to_opportunity_owner_when_Deal_approval_exactly_60_days</template>
    </alerts>
    <alerts>
        <fullName>FS_Fixed_Price_Review_of_Opportunity_Product</fullName>
        <description>Fixed Price Review of Opportunity Product</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_AFM_Approvers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Fixed_Price_Review_of_Opportunity_Product</template>
    </alerts>
    <alerts>
        <fullName>FS_Notification_of_New_Business_Opportunity_set_to_Won</fullName>
        <description>Notification of New Business Opportunity set to Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>FS_US_Supply_Chain</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/Opportunity_Won_Email_to_US_Supply_Chain</template>
    </alerts>
    <alerts>
        <fullName>TPR_Approval_Action</fullName>
        <description>TPR Approval Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_TPR_Opportunity_Approval_Action_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>To_send_a_Email_3_days_after_opportunity_closed_date</fullName>
        <description>To send a Email 3 days after opportunity closed date</description>
        <protected>false</protected>
        <recipients>
            <field>FS_Owner_Manager__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Stage_after_3_days_on_closed_date</template>
    </alerts>
    <alerts>
        <fullName>To_send_a_Email_one_week_before_opportunity_closed_date</fullName>
        <description>To send a Email one week before opportunity closed date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Stage_before_7_days_of_Oppty_Closed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Approved_Update_Step2</fullName>
        <description>To Update Deal Approved from false to true</description>
        <field>DealApproved__c</field>
        <literalValue>1</literalValue>
        <name>Deal Approved Update Step2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Approved_Update_set_to_false</fullName>
        <description>Deal approved update set as false when opportunity in final reject .</description>
        <field>DealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Approved Update set to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_DealUpdate</fullName>
        <field>DealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Stage_Update</fullName>
        <description>Opportunity should be submitted when in Stage 03 &quot;In the funnel.&quot; Once worked through the approval process successfully, should automatically be set to stage = &apos;04 Best Few&apos;.</description>
        <field>StageName</field>
        <literalValue>04 - Verbal Commitment</literalValue>
        <name>Stage Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Owner_Manager</fullName>
        <description>Updates users Manager</description>
        <field>FS_Owner_Manager__c</field>
        <formula>Owner.Manager.Email</formula>
        <name>FS Update Owner Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Record_Locked</fullName>
        <description>Set the Record locked field to true</description>
        <field>FS_RecordLocked__c</field>
        <literalValue>1</literalValue>
        <name>Update Record Locked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_Stage_New_to_Negotiation</fullName>
        <description>Update the Stage field from New to Negotiation.</description>
        <field>StageName</field>
        <literalValue>2-Negotiation</literalValue>
        <name>Update Stage New to Negotiation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_TPR_Approved</fullName>
        <description>Update the TPR Approved field</description>
        <field>FS_TPRApproved__c</field>
        <literalValue>1</literalValue>
        <name>Update TPR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FS_Update_TPR_Approved_by_Line_Manager</fullName>
        <description>Purpose: tagged the TPR Approved by Line Manager flag in Opportunity</description>
        <field>FS_TPRApprovedByLineManager__c</field>
        <literalValue>1</literalValue>
        <name>Update TPR Approved by Line Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FS Email to opportunity owner when Deal approval exactly 60 days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.DealApproved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>05 – Won</value>
        </criteriaItems>
        <description>Any time Deal Approved on opportunity is set to True, it should expire in 61 days.By expire,that field should be set back to False &amp; Email must be sent to Opp Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_to_Opp_Owner</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>FS_DealUpdate</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FS Funnel Stage Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>04 - Verbal Commitment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Opportunity with Pricing (MA-BE)</value>
        </criteriaItems>
        <description>Sends the notification to owner of the record 7 days before the closed date and also sends the notification to the owner and his manager after 3 days of closed date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>To_send_a_Email_3_days_after_opportunity_closed_date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>To_send_a_Email_one_week_before_opportunity_closed_date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FS Update oppty owner manager</fullName>
        <actions>
            <name>FS_Update_Owner_Manager</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updated opportunity manager in the owner manager field</description>
        <formula>OR ( ISNEW(), ISCHANGED(OwnerId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FS_US_Notify_Supply_Chain_Opportunity_Set_to_Won</fullName>
        <actions>
            <name>FS_Notification_of_New_Business_Opportunity_set_to_Won</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 or 2) and 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>05 – Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>05 - Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>&quot;USD 500,000&quot;</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Product</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
