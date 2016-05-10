<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_request_email_template_to_Step3_approver</fullName>
        <description>&quot;Approval request email template&quot; to Step3 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>maha.r.bhaskar.reddy@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ramesh.suddapalli@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Opportunity_approval_request_email_template</template>
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
        <recipients>
            <recipient>maha.r.bhaskar.reddy@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_Step_2_approver</fullName>
        <description>&quot;Approval request email template&quot; to Step 2 approver</description>
        <protected>false</protected>
        <recipients>
            <recipient>AFM_Approvers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Approval_request_email_template_to_approver_for_Final_Approve</fullName>
        <description>&quot;Approval request email template&quot; to approver for Final Approve</description>
        <protected>false</protected>
        <recipients>
            <recipient>ramesh.suddapalli@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Opportunity_approval_request_email_template</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Opp_Owner</fullName>
        <description>Email Alert to Opp Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NAFS_Email_Templates/NAFS_Email_to_opportunity_owner_when_Deal_approval_exactly_60_days</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deal_Approved_Update_Step2</fullName>
        <description>To Update Deal Approved from false to true</description>
        <field>NAFSDealApproved__c</field>
        <literalValue>1</literalValue>
        <name>Deal Approved Update Step2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Approved_Update_set_to_false</fullName>
        <description>Deal approved update set as false when opportunity in final reject .</description>
        <field>NAFSDealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Approved Update set to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Update</fullName>
        <field>NAFSDealApproved__c</field>
        <literalValue>0</literalValue>
        <name>Deal Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NFS_UpdateProfitable1</fullName>
        <field>NFS_Profitable__c</field>
        <literalValue>1</literalValue>
        <name>Update Profitable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NAFS Email to opportunity owner when Deal approval exactly 60 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.NAFSDealApproved__c</field>
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
                <name>Deal_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NFS Update Profitability Checkbox</fullName>
        <actions>
            <name>NFS_UpdateProfitable1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.NFS_PBIPercent__c</field>
            <operation>greaterOrEqual</operation>
            <value>20</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.NFS_CUMCFYear2__c</field>
            <operation>greaterThan</operation>
            <value>EUR 0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
