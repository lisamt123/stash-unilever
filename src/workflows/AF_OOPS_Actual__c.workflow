<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AF_OOPS_Actual_Approved</fullName>
        <description>OOPS Actual Approved</description>
        <protected>false</protected>
        <recipients>
            <field>AF_AgencyUsers1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers4__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers5__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_OOPS_Actual_Approved_HTML</template>
    </alerts>
    <alerts>
        <fullName>AF_OOPS_Actual_Rejected</fullName>
        <description>OOPS Actual Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>AF_AgencyUsers1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers4__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers5__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_OOPS_Actual_Rejected_HTML</template>
    </alerts>
    <alerts>
        <fullName>AF_OOPS_Actual_Submitted</fullName>
        <description>OOPS Actual Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>AF_Cat_Finance_Email_1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Email_3__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Email_4__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Email_5__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_OOPS_Actual_Submitted_HTML</template>
    </alerts>
    <alerts>
        <fullName>Notify_AgencyUsers_OOPS</fullName>
        <description>Notify Agency users when Category Finance reject</description>
        <protected>false</protected>
        <recipients>
            <field>AF_AgencyUsers1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers3__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_AgencyRejection_OOPS_HTML</template>
    </alerts>
    <alerts>
        <fullName>Notify_Category_Finance_Users_upon_submission_by_Agency_users</fullName>
        <description>Notify Category Finance Users upon submission by Agency users</description>
        <protected>false</protected>
        <recipients>
            <recipient>AF_Agency_User_Public_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AF_AgencySubmission_OOPS_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_OOPS</fullName>
        <field>AF_Status__c</field>
        <literalValue>Ready For PO</literalValue>
        <name>Approval OOPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Rejected</fullName>
        <field>AF_Status__c</field>
        <literalValue>With Agency</literalValue>
        <name>Approval Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Update</fullName>
        <field>AF_Status__c</field>
        <literalValue>Ready For PO</literalValue>
        <name>Approval Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>AF_Status__c</field>
        <literalValue>With Category Finance</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OOPS Actual Approved</fullName>
        <actions>
            <name>AF_OOPS_Actual_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>OR( ISCHANGED(AF_Status_Q1__c) &amp;&amp;  ISPICKVAL(AF_Status_Q1__c, &apos;Approved&apos;),  ISCHANGED(AF_Status_Q2__c) &amp;&amp;  ISPICKVAL(AF_Status_Q2__c, &apos;Approved&apos;),  ISCHANGED(AF_Status_Q3__c) &amp;&amp;  ISPICKVAL(AF_Status_Q3__c, &apos;Approved&apos;),  ISCHANGED(AF_Status_Q4__c) &amp;&amp;  ISPICKVAL(AF_Status_Q4__c, &apos;Approved&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOPS Actual Rejected</fullName>
        <actions>
            <name>AF_OOPS_Actual_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>OR( ISCHANGED( AF_Status_Q1__c) &amp;&amp; ISCHANGED( AF_Q1_Backup__c ) &amp;&amp; AF_Q1_Backup__c=false, ISCHANGED( AF_Status_Q2__c) &amp;&amp; ISCHANGED( AF_Q2_Backup__c ) &amp;&amp; AF_Q2_Backup__c=false, ISCHANGED( AF_Status_Q3__c) &amp;&amp; ISCHANGED( AF_Q3_Backup__c ) &amp;&amp; AF_Q3_Backup__c=false, ISCHANGED( AF_Status_Q4__c) &amp;&amp; ISCHANGED( AF_Q4_Backup__c ) &amp;&amp; AF_Q4_Backup__c=false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOPS Actual Submitted</fullName>
        <actions>
            <name>AF_OOPS_Actual_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 or 2 or 3 or 4</booleanFilter>
        <criteriaItems>
            <field>AF_OOPS_Actual__c.AF_Status_Q1__c</field>
            <operation>equals</operation>
            <value>With Category Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_OOPS_Actual__c.AF_Status_Q2__c</field>
            <operation>equals</operation>
            <value>With Category Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_OOPS_Actual__c.AF_Status_Q3__c</field>
            <operation>equals</operation>
            <value>With Category Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_OOPS_Actual__c.AF_Status_Q4__c</field>
            <operation>equals</operation>
            <value>With Category Finance</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
