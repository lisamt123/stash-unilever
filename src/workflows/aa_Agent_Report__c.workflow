<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AA_Add_New_Brand_Review_To_ETS</fullName>
        <ccEmails>hampesh.pda@gmail.com</ccEmails>
        <description>AA Add New Brand Review To ETS</description>
        <protected>false</protected>
        <recipients>
            <recipient>ETS_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AA_Email_Templates/AA_ETS_To_CIManager_Add_New_Brand</template>
    </alerts>
    <alerts>
        <fullName>AA_ETS_To_CIManager_Add_New_Brand_Review</fullName>
        <ccEmails>asleshagujarathi@gmail.com</ccEmails>
        <description>AA ETS To CIManager Add New Brand Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>CI_Manager_Default</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/AA_ETS_To_CIManager_Add_New_Brand</template>
    </alerts>
    <alerts>
        <fullName>AA_Report_Accepted</fullName>
        <description>AA_Report_Accepted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/AA_Report_Accepted1</template>
    </alerts>
    <alerts>
        <fullName>AA_Report_Rejected</fullName>
        <description>AA_Report_Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/AA_Report_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Mail_To_ETS_Members</fullName>
        <description>Mail To ETS Members</description>
        <protected>false</protected>
        <recipients>
            <recipient>ETS_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/Unilver_Custom_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_email_notification_to_CI_manager_for_Approval</fullName>
        <description>Send email notification to CI manager for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AA_Email_Templates/AA_ETS_To_CIManager</template>
    </alerts>
    <fieldUpdates>
        <fullName>AA_ETS_Owner_Assignment</fullName>
        <field>OwnerId</field>
        <lookupValue>ETS_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AA_ETS_Owner_Assignment</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Name_to_Report</fullName>
        <field>Name</field>
        <formula>LPAD( Report_Title__c,80 )</formula>
        <name>Add Name to Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Manager_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CI_Manger_Record_type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>CI Manager Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ETS_Record_Type_Assigned</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ETS_Members_Record_Type</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ETS Record Type Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Agent_Report_Status_to_Published</fullName>
        <field>Status__c</field>
        <literalValue>Published (Public)</literalValue>
        <name>Set Agent Report Status to Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Unilever_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Unilever_Agent_Published_Report</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Unilever Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_PublicPublish</fullName>
        <field>Status__c</field>
        <literalValue>Published (Public)</literalValue>
        <name>Status_PublicPublish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>ETS Approval Pending</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_To_Competitor</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Competitor_Report</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type To Competitor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AA Add Name to Report</fullName>
        <actions>
            <name>Add_Name_to_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Report_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA Other Brand Notification to CI</fullName>
        <actions>
            <name>AA_ETS_To_CIManager_Add_New_Brand_Review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>CI Manager Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherBrandName__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherCompanyName__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <description>This workflow will send email to CI cluster manager when report is assigned to them</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA Other Brand Notification to ETS</fullName>
        <actions>
            <name>AA_Add_New_Brand_Review_To_ETS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherBrandName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.OtherCompanyName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA_ApprovedBy_ETS_Group</fullName>
        <actions>
            <name>AA_Report_Accepted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Status_PublicPublish</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Record_Type_To_Competitor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Approve_Reject__c</field>
            <operation>equals</operation>
            <value>Approve</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA_ETS_To_CIManager</fullName>
        <active>true</active>
        <formula>(Owner:Queue.QueueName = &apos;CI Manager Africa Queue&apos;) || (Owner:Queue.QueueName = &apos;CI Manager Europe Queue&apos;) || (Owner:Queue.QueueName = &apos;CI Manager Latin America Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager NametRub Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager North America Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager South Asia Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager North Asia Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager SEAA Queue&apos;)|| (Owner:Queue.QueueName = &apos;CI Manager Default Queue&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AA_RejectedBy_ETS_Group</fullName>
        <actions>
            <name>Status_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Approve_Reject__c</field>
            <operation>equals</operation>
            <value>Reject</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assignment To ETS Group</fullName>
        <actions>
            <name>Mail_To_ETS_Members</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AA_ETS_Owner_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ETS_Record_Type_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Competitor Report</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email to CI Manager</fullName>
        <actions>
            <name>Send_email_notification_to_CI_manager_for_Approval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>CI Manager Approval Pending</value>
        </criteriaItems>
        <description>This workflow will send email to CI cluster manager when report is assigned to them</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Unilever Agent Report Recordtype</fullName>
        <actions>
            <name>Set_Unilever_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Unilever Agent Report</value>
        </criteriaItems>
        <description>If the agent report is about Unilever products the record does not need to be reviewed and can be published (status is updated via this rule and criteria based sharing rule kicks in)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Unilever Agent Report Status</fullName>
        <actions>
            <name>Set_Agent_Report_Status_to_Published</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Unilever Agent Published Report</value>
        </criteriaItems>
        <criteriaItems>
            <field>aa_Agent_Report__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>If the agent report is about Unilever products the record does not need to be reviewed and can be published (status is updated via this rule and criteria based sharing rule kicks in)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Unilever Agent Report to Published</fullName>
        <actions>
            <name>Set_Unilever_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>aa_Agent_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Unilever Agent Report</value>
        </criteriaItems>
        <description>If the agent report is about Unilever products the record does not need to be reviewed and can be published (status is updated via this rule and criteria based sharing rule kicks in)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
