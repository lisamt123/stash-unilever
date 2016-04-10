<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Milestone_Due_Date_in_the_past</fullName>
        <description>IPM Milestone Due Date in the past</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Deputy_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>IPM_Gatekeeper_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>IPM_Project_Leader_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_Due_Date_in_the_past2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Due_Date</fullName>
        <field>IPM_Due_Date__c</field>
        <formula>IPM_Planned_Date__c</formula>
        <name>Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_BET_FU_MS_Update_StatusCheck</fullName>
        <field>BET_Status_Check_Trigger__c</field>
        <literalValue>1</literalValue>
        <name>IPM_BET_FU_MS_Update_StatusCheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Milestone_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project__r.IPM_Project_Name__c + &apos;-&apos; + TEXT( IPM_Project_Type__c ) +&apos;-&apos; + IPM_Name__c, 78)</formula>
        <name>Update Milestone Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Suggested Date</fullName>
        <actions>
            <name>Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(AND( ISPICKVAL(IPM_Project__r.IPM_Project_Type__c, &quot;Operational&quot;), ( ISPICKVAL( IPM_Type_of_gate__c  ,&quot;Market Ready&quot;) ),ISPICKVAL( IPM_Type_of_Milestone__c ,&quot;BET&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM Milestone Due Date in the Past</fullName>
        <actions>
            <name>IPM_Milestone_Due_Date_in_the_past</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(  IPM_Milestone_Due_Date_In_Past__c = true,  NOT(ISPICKVAL( IPM_Phase__c , &apos;Post Launch Evaluation&apos;)),  IPM_Project__r.Is_Archieved__c = false,  ISPICKVAL( IPM_Type_of_Milestone__c , &apos;Standard&apos;),  IPM_Completed__c = false,  CreatedDate  &lt;&gt;  LastModifiedDate    )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM_BET_WF_Trigger_MS_StatusCheck</fullName>
        <active>true</active>
        <formula>AND(IPM_Due_Date__c &lt;&gt;NULL, IPM_Due_Date__c&gt;= TODAY(),ISPICKVAL(IPM_Type_of_Milestone__c, &apos;BET&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_BET_FU_MS_Update_StatusCheck</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Milestone__c.IPM_Due_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Rename Milestone Name</fullName>
        <actions>
            <name>Update_Milestone_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
