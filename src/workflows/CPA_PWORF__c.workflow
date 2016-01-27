<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CAP_Email_after_PWORF_is_Accepted</fullName>
        <description>CAP Email after PWORF is Accepted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CAP_Email_after_PWORF_is_Submitted</fullName>
        <description>CAP Email after PWORF is Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULFT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Unilever_project_manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_ULPM</template>
    </alerts>
    <alerts>
        <fullName>CAP_PWORF_returned_by_VDM</fullName>
        <description>CAP PWORF returned by VDM</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULFT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Return_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CAP_Pworf_Withhold</fullName>
        <description>CAP Pworf Withhold</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULFT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPM_group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Withheld_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_Email_PWORF_is_Submitted</fullName>
        <description>CPA Email PWORF is Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_ULPM</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Accepted_Email_Alert</fullName>
        <description>CPA PWORF Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Auto_Accepted_Email_Alert</fullName>
        <description>CPA PWORF Auto Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Auto_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Cancelled_Email_Alert</fullName>
        <description>CPA PWORF Cancelled Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Cancelled_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Re_Submitted_Email_Alert</fullName>
        <description>CPA PWORF Re-Submitted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Resubmitted_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Returned_Email_Alert</fullName>
        <description>CPA PWORF Returned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Return_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Submitted_Email_Alert</fullName>
        <description>CPA PWORF Submitted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Withhold_Email_Alert</fullName>
        <description>CPA PWORF Withhold Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_ULPT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>CAP_VDM_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Withheld_by_SMT</template>
    </alerts>
    <fieldUpdates>
        <fullName>CAP_Manually_Accepted</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Accepted</literalValue>
        <name>CAP  Manually Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_Owner_Update</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_ULPM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CAP Owner Update</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_Owner_Update_to_ULPM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_ULPM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CAP Owner Update to ULPM</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Withhold_Resubmitted_date</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <name>CAP PWORF Withhold_Resubmitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Withhold_SLA1_Date</fullName>
        <field>dat_SLA1_Accepted_Date__c</field>
        <name>CAP PWORF Withhold_SLA1 Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Withhold_SLA1_Days</fullName>
        <field>Number_of_SLA1_Days__c</field>
        <formula>VALUE(txt_SLA1__c ) -( dat_Withhold_Date__c - dat_Resubmitted_Date__c )</formula>
        <name>CAP PWORF Withhold_SLA1 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Withhold_Withhold_Date</fullName>
        <field>dat_Withhold_Date__c</field>
        <formula>TODAY()</formula>
        <name>CAP PWORF Withhold_Withhold Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_returned</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Returned</literalValue>
        <name>CAP  PWORF returned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_Pworf_Reject</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Reject</literalValue>
        <name>CAP  Pworf Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Breach_Applicable</fullName>
        <field>pkl_Breach_Applicable__c</field>
        <literalValue>YES</literalValue>
        <name>CPA Breach Applicable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Owner_Update_to_VDM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA Owner Update to VDM</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Accepted_Date_Update</fullName>
        <field>dat_SLA1_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Accepted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Auto_Accepted_Date_Update</fullName>
        <field>dat_Auto_Accepted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Auto Accepted Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Cancelled_Date_Update</fullName>
        <field>dat_Cancelled_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Cancelled Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Cancelled_Status</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>CPA PWORF Cancelled Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Recall</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Withhold</literalValue>
        <name>CPA PWORF Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_ExpectedSLA1_date</fullName>
        <field>dat_Expected_SLA1_Date__c</field>
        <formula>CASE( 
MOD(dat_Resubmitted_Date__c - DATE(1900, 1, 7), 7), 
0, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c-1)/5)*2, 
1, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c)/5)*2, 
2, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+1)/5)*2, 
3, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+2)/5)*2, 
4, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+3)/5)*2, 
5, (dat_Resubmitted_Date__c ) + Number_of_SLA1_Days__c + CEILING((Number_of_SLA1_Days__c)/5)*2, 
6, (dat_Resubmitted_Date__c ) - IF(Number_of_SLA1_Days__c&gt;0,1,0) + Number_of_SLA1_Days__c + CEILING((Number_of_SLA1_Days__c)/5)*2, 
null)</formula>
        <name>CPA PWORF Resubmitted_ExpectedSLA1 date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_Re_Submitted_date</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Resubmitted_Re-Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_SLA1_date</fullName>
        <field>dat_SLA1_Accepted_Date__c</field>
        <formula>CASE(
MOD(dat_Resubmitted_Date__c   - DATE(1900, 1, 7), 7),
0, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c-1)/5)*2,
1, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c)/5)*2,
2, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+1)/5)*2,
3, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+2)/5)*2,
4, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + FLOOR((Number_of_SLA1_Days__c+3)/5)*2,
5, (dat_Resubmitted_Date__c  ) + Number_of_SLA1_Days__c + CEILING((Number_of_SLA1_Days__c)/5)*2,
6, (dat_Resubmitted_Date__c  ) - IF(Number_of_SLA1_Days__c&gt;0,1,0) + Number_of_SLA1_Days__c + CEILING((Number_of_SLA1_Days__c)/5)*2,
null)</formula>
        <name>CPA PWORF Resubmitted_SLA1 date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Returned_Date_Update</fullName>
        <field>dat_VDM_Request_return_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Returned Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submited_submittedDate</fullName>
        <field>dat_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Submited_submittedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submitted_Re_Submitted_date</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Submitted_Re-Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submitted_SLA1</fullName>
        <field>Number_of_SLA1_Days__c</field>
        <formula>7</formula>
        <name>CPA PWORF Submitted SLA1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submitted_SLA1_Date</fullName>
        <field>dat_SLA1_Accepted_Date__c</field>
        <formula>CASE(
MOD(dat_Submitted_Date__c  - DATE(1900, 1, 7), 7),
0, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)-1)/5)*2,
1, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c))/5)*2,
2, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+1)/5)*2,
3, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+2)/5)*2,
4, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+3)/5)*2,
5, (dat_Submitted_Date__c ) + VALUE(txt_SLA1__c) + CEILING((VALUE(txt_SLA1__c))/5)*2,
6, (dat_Submitted_Date__c ) - IF(VALUE(txt_SLA1__c)&gt;0,1,0) + VALUE(txt_SLA1__c) + CEILING((VALUE(txt_SLA1__c))/5)*2,
null)</formula>
        <name>CPA PWORF Submitted_SLA1 Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submitted_dat_Expected_SLA1_Da</fullName>
        <field>dat_Expected_SLA1_Date__c</field>
        <name>CPA PWORF Submitted_dat_Expected_SLA1_Da</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Withhold_Date_update</fullName>
        <field>dat_Withhold_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Withhold Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Penalty_Applicable</fullName>
        <field>pkl_Penalty_Applicable__c</field>
        <literalValue>YES</literalValue>
        <name>CPA Penalty Applicable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Status_Saved</fullName>
        <description>When PWORF is cloned/Created, STATUS is kept Saved.</description>
        <field>pkl_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>CPA Status Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Auto Accepted</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isCancelled_False</fullName>
        <field>isCancelled__c</field>
        <literalValue>0</literalValue>
        <name>isCancelled False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPA PWORF Accepted</fullName>
        <actions>
            <name>CPA_PWORF_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Accepted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Auto Accepted</fullName>
        <actions>
            <name>CPA_PWORF_Auto_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Auto_Accepted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Auto Accepted</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Cancelled</fullName>
        <actions>
            <name>CPA_PWORF_Cancelled_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Cancelled_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Cancelled_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.isCancelled__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Cloned%2FCreated</fullName>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <description>When PWORF is Cloned/Created, STATUS is set to Saved.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Resubmitted</fullName>
        <actions>
            <name>CPA_PWORF_Re_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_ExpectedSLA1_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_Re_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_SLA1_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.txt_SLA1__c</field>
            <operation>notEqual</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.txt_SLA1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Returned</fullName>
        <actions>
            <name>CPA_PWORF_Returned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Returned_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Withhold</fullName>
        <actions>
            <name>CPA_PWORF_Withhold_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_Resubmitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_SLA1_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_SLA1_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_Withhold_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Submitted_dat_Expected_SLA1_Da</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Withhold</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.txt_SLA1__c</field>
            <operation>notEqual</operation>
            <value>NA</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.txt_SLA1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow will fire after the status for PWORF will be Withhold update the date fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF submitted</fullName>
        <actions>
            <name>CPA_PWORF_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>This workflow will fire after the status for PWORF will be Submitted update the date fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF submitted1</fullName>
        <actions>
            <name>CPA_PWORF_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>This workflow will fire after the status for PWORF will be Submitted update the date fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA SLA2 BreachCheck</fullName>
        <actions>
            <name>CPA_Breach_Applicable</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Penalty_Applicable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(OR(NOT(ISBLANK(dat_Revised_Submission_Date__c)),NOT(ISBLANK(dat_Expected_SLA2_Date__c))),IF(OR((AND(ISBLANK(dat_Revised_Submission_Date__c),dat_Expected_SLA2_Date__c == TODAY())),((AND(NOT(ISBLANK(dat_Revised_Submission_Date__c)),dat_Revised_Submission_Date__c == TODAY())))),true,false),false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status Auto Approved</fullName>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
        </criteriaItems>
        <description>This rule set up to change the PWORF status to auto accepted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Submitted_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
