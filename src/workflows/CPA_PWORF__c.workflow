<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CAP_Email_PWORF_is_Submitted</fullName>
        <description>CAP Email PWORF is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_ULPM</template>
    </alerts>
    <alerts>
        <fullName>CAP_Email_after_PWORF_is_Accepted</fullName>
        <description>CAP Email after PWORF is Accepted</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CAP_Email_after_PWORF_is_Submitted</fullName>
        <description>CAP Email after PWORF is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
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
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Return_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CAP_Pworf_Withhold</fullName>
        <description>CAP Pworf Withhold</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Withheld_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_Email_PWORF_is_Submitted</fullName>
        <description>CPA Email PWORF is Submitted</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_ULPM</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Accepted_Email_Alert</fullName>
        <description>CPA PWORF Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Auto_Accepted_Email_Alert</fullName>
        <description>CPA PWORF Auto Accepted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Auto_Accept_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Cancelled_Email_Alert</fullName>
        <description>CPA PWORF Cancelled Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Cancelled_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Re_Submitted_Email_Alert</fullName>
        <description>CPA PWORF Re-Submitted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Resubmitted_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Reminder_to_respond_to_PWORF_SLA1</fullName>
        <description>CPA PWORF Reminder to respond to PWORF SLA1</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Reminder_to_respond_to_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Reminder_to_submit_PWO_SLA2</fullName>
        <description>CPA PWORF Reminder to submit PWO SLA2</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Reminder_to_submit_PWO</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Returned_Email_Alert</fullName>
        <description>CPA PWORF Returned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Return_PWORF</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Submitted_Email_Alert</fullName>
        <description>CPA PWORF Submitted Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Submitted_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_Withhold_Email_Alert</fullName>
        <description>CPA PWORF Withhold Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>eml_VDM_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Withheld_by_SMT</template>
    </alerts>
    <alerts>
        <fullName>CPA_PWORF_reminder_for_Clarity_ID</fullName>
        <description>CPA PWORF reminder for Clarity ID</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>lkp_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_Reminder_to_enter_a_Clarity_ID</template>
    </alerts>
    <fieldUpdates>
        <fullName>Accepted_Action_field_Udate</fullName>
        <description>PWORF is Accepted by Vendor.</description>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Accepted by Vendor&quot;</formula>
        <name>Accepted Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Action_field_Udate</fullName>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Submitted successfully and waiting for Vendor&apos;s Approval.&quot;</formula>
        <name>Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Comment_Requested_for_PWORF</fullName>
        <field>pkl_Approval_Comment_Check__c</field>
        <literalValue>Requested</literalValue>
        <name>Approval Comment Requested for PWORF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Comment_Required_for_PWORF</fullName>
        <field>pkl_Approval_Comment_Check__c</field>
        <literalValue>Required</literalValue>
        <name>Approval Comment Required for PWORF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Auto_Accepted_Action_field_Udate</fullName>
        <description>PWORF is Auto Accepted.</description>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Auto Accepted&quot;</formula>
        <name>Auto Accepted Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_Owner_Update_to_VDM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CAP Owner Update to VDM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Recall</fullName>
        <field>pkl_Status__c</field>
        <literalValue>Withhold</literalValue>
        <name>CAP PWORF Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Return_Num_SLA1_Days</fullName>
        <field>num_Number_of_SLA1_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA1__c) , (VALUE(  txt_SLA1__c )-(IF(ISBLANK(dat_Resubmitted_Date__c),(CASE(MOD(dat_Submitted_Date__c-DATE(1985,6,24),7), 
0,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999)+(FLOOR((TODAY()-dat_Submitted_Date__c)/7)*5)),(CASE(MOD(dat_Resubmitted_Date__c-DATE(1985,6,24),7), 
0,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999)+(FLOOR((TODAY()-dat_Resubmitted_Date__c)/7)*5))))) , 0)</formula>
        <name>CAP PWORF Return_Num_SLA1 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CAP_PWORF_Return_Num_SLA2_Days</fullName>
        <field>num_Number_of_SLA2_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA2__c) , (VALUE( txt_SLA2__c )-(IF(ISBLANK(dat_Resubmitted_Date__c),(CASE(MOD(dat_Submitted_Date__c-DATE(1985,6,24),7), 
0,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6,CASE(MOD(TODAY()-dat_Submitted_Date__c,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999)+(FLOOR((TODAY()-dat_Submitted_Date__c)/7)*5)),(CASE(MOD(dat_Resubmitted_Date__c-DATE(1985,6,24),7), 
0,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6,CASE(MOD(TODAY()-dat_Resubmitted_Date__c,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999)+(FLOOR((TODAY()-dat_Resubmitted_Date__c)/7)*5))))) , 0)</formula>
        <name>CAP PWORF Return_Num_SLA2 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>CPA_Breach_Applicable</fullName>
        <field>pkl_Breach_Applicable__c</field>
        <literalValue>YES</literalValue>
        <name>CPA Breach Applicable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Change_the_Owner_to_ULPM_after_Withh</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_ULPM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA Change the Owner to ULPM after Withh</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Date_of_Acceptance_field_Update</fullName>
        <description>to update Date of Acceptance  when pworf is updated.</description>
        <field>dt_Date_Of_Acceptance__c</field>
        <formula>TODAY()</formula>
        <name>CPA Date of Acceptance field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Date_of_Request_field_update</fullName>
        <description>Set date for creation as Date of Request i.e TODAY()</description>
        <field>dt_Date_Of_Request__c</field>
        <formula>Today()</formula>
        <name>CPA Date of Request field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Date_of_Submission_update</fullName>
        <description>Date of Submission will be set to current date.</description>
        <field>dat_Submitted_Date__c</field>
        <formula>Today()</formula>
        <name>CPA Date of Submission update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Owner_Update_to_VDM</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_VDM_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA Owner Update to VDM</name>
        <notifyAssignee>false</notifyAssignee>
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
        <fullName>CPA_PWORF_Approval_started</fullName>
        <field>isApprovalProcessStarted__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF Approval started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
        <fullName>CPA_PWORF_IsAccepted_True</fullName>
        <field>chk_isAccepted__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF IsAccepted True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>CPA_PWORF_Resubmitted_Re_Submitted_date</fullName>
        <field>dat_Resubmitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>CPA PWORF Resubmitted_Re-Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_isreturn_false</fullName>
        <field>chk_isReturned__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWORF Resubmitted isreturn false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_iswithhold_false</fullName>
        <field>chk_isWithhold__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWORF Resubmitted iswithhold false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_return_date_null</fullName>
        <field>dat_VDM_Request_return_Date__c</field>
        <name>CPA PWORF Resubmitted return date null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Resubmitted_withhold_date_null</fullName>
        <field>dat_Withhold_Date__c</field>
        <name>CPA PWORF Resubmitted withhold date null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Retur_no_of_SLA1_day_remaining</fullName>
        <field>num_Number_of_SLA1_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA1__c),(IF(NOT(chk_isReSubmitted__c),(num_Number_of_SLA1_Days__c -((CASE(MOD( dat_Submitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Submitted_Date__c )/7)*5) ) -1)),(num_Number_of_SLA1_Days__c -((CASE(MOD( dat_Resubmitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Resubmitted_Date__c )/7)*5) ) -1)))), null)</formula>
        <name>CPA PWORF Retur no of SLA1 day remaining</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Return_Isreturn</fullName>
        <field>chk_isReturned__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF Return Isreturn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Return_SLA2_date_null</fullName>
        <field>dat_Expected_SLA2_Date__c</field>
        <name>CPA PWORF Return SLA2 date null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
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
        <fullName>CPA_PWORF_Revised_Submission_Date_blank</fullName>
        <field>dat_Revised_Submission_Date__c</field>
        <name>CPA PWORF Revised Submission Date blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_SLA1_blank</fullName>
        <field>txt_SLA1__c</field>
        <name>CPA PWORF SLA1 blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_SLA2_Breach_Applicable_no</fullName>
        <field>pkl_Breach_Applicable__c</field>
        <literalValue>No</literalValue>
        <name>CPA PWORF SLA2 Breach Applicable no</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_SLA2_Penalty_Applicable_no</fullName>
        <field>pkl_Penalty_Applicable__c</field>
        <literalValue>No</literalValue>
        <name>CPA PWORF SLA2 Penalty Applicable no</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_SLA2_blank</fullName>
        <field>txt_SLA2__c</field>
        <name>CPA PWORF SLA2 blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_SMT_group_email</fullName>
        <field>eml_SMT_group_email__c</field>
        <formula>&quot;ApplicationSupplier.PM@unilever.com&quot;</formula>
        <name>CPA PWORF SMT group email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submit_Resubmit_SLA1</fullName>
        <field>dat_Expected_SLA1_Date__c</field>
        <formula>IF( NOT(ISNULL(num_Number_of_SLA1_Days__c)), (CASE( 
MOD(TODAY() - DATE(1900, 1, 7), 7), 
0, TODAY() + num_Number_of_SLA1_Days__c+ FLOOR((num_Number_of_SLA1_Days__c-1)/5)*2, 
1, TODAY() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c)/5)*2, 
2, TODAY() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+1)/5)*2, 
3, TODAY() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+2)/5)*2, 
4, TODAY() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+3)/5)*2, 
5, TODAY() + num_Number_of_SLA1_Days__c + CEILING((num_Number_of_SLA1_Days__c)/5)*2, 
6, TODAY() - IF((num_Number_of_SLA1_Days__c)&gt;0,1,0) + num_Number_of_SLA1_Days__c + CEILING(((num_Number_of_SLA1_Days__c))/5)*2, 
null)),null)</formula>
        <name>CPA PWORF Submit/Resubmit SLA1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submit_Resubmit_SLA2</fullName>
        <field>dat_Expected_SLA2_Date__c</field>
        <formula>IF( NOT(ISNULL(num_Number_of_SLA2_Days__c )), (CASE( 
MOD(TODAY() - DATE(1900, 1, 7), 7), 
0, TODAY() + num_Number_of_SLA2_Days__c + FLOOR((num_Number_of_SLA2_Days__c -1)/5)*2, 
1, TODAY() + num_Number_of_SLA2_Days__c + FLOOR((num_Number_of_SLA2_Days__c )/5)*2, 
2, TODAY() + num_Number_of_SLA2_Days__c + FLOOR((num_Number_of_SLA2_Days__c +1)/5)*2, 
3, TODAY() + num_Number_of_SLA2_Days__c + FLOOR((num_Number_of_SLA2_Days__c +2)/5)*2, 
4, TODAY() + num_Number_of_SLA2_Days__c + FLOOR((num_Number_of_SLA2_Days__c +3)/5)*2, 
5, TODAY() + num_Number_of_SLA2_Days__c + CEILING((num_Number_of_SLA2_Days__c )/5)*2, 
6, TODAY() - IF((num_Number_of_SLA2_Days__c )&gt;0,1,0) + num_Number_of_SLA2_Days__c + CEILING(((num_Number_of_SLA2_Days__c ))/5)*2, 
null)),null)</formula>
        <name>CPA PWORF Submit/Resubmit SLA2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>CPA_PWORF_Submitted_SLA1_Date</fullName>
        <field>dat_Expected_SLA1_Date__c</field>
        <formula>IF((AND(chk_isReturned__c,NOT(chk_isWithhold__c),NOT(ISBLANK(txt_SLA1__c)),NOT(txt_SLA1__c==&apos;NA&apos;))),(CASE(
MOD(Today() - DATE(1900, 1, 7), 7),
0, Today() + num_Number_of_SLA1_Days__c+ FLOOR((num_Number_of_SLA1_Days__c-1)/5)*2,
1, Today() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c)/5)*2,
2, Today() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+1)/5)*2,
3, Today() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+2)/5)*2,
4, Today() + num_Number_of_SLA1_Days__c + FLOOR((num_Number_of_SLA1_Days__c+3)/5)*2,
5, Today() + num_Number_of_SLA1_Days__c + CEILING((num_Number_of_SLA1_Days__c)/5)*2,
6, Today() - IF((num_Number_of_SLA1_Days__c)&gt;0,1,0) + num_Number_of_SLA1_Days__c + CEILING(((num_Number_of_SLA1_Days__c))/5)*2,
null)), (IF((AND(NOT(ISBLANK(txt_SLA1__c)),NOT(txt_SLA1__c==&apos;NA&apos;))),(CASE(
MOD(Today() - DATE(1900, 1, 7), 7),
0, Today() + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)-1)/5)*2,
1, Today() + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c))/5)*2,
2, Today() + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+1)/5)*2,
3, Today() + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+2)/5)*2,
4, Today() + VALUE(txt_SLA1__c) + FLOOR((VALUE(txt_SLA1__c)+3)/5)*2,
5, Today() + VALUE(txt_SLA1__c) + CEILING((VALUE(txt_SLA1__c))/5)*2,
6, Today() - IF(VALUE(txt_SLA1__c)&gt;0,1,0) + VALUE(txt_SLA1__c) + CEILING((VALUE(txt_SLA1__c))/5)*2,
null)),null)))</formula>
        <name>CPA PWORF Submitted_SLA1 Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_Submitted_SLA2_Date</fullName>
        <field>dat_Expected_SLA2_Date__c</field>
        <formula>IF((AND(NOT(ISBLANK(txt_SLA2__c)),NOT(txt_SLA2__c==&apos;NA&apos;))),(CASE( 
MOD(Today() - DATE(1900, 1, 7), 7), 
0, Today() + VALUE(txt_SLA2__c) + FLOOR((VALUE(txt_SLA2__c)-1)/5)*2, 
1, Today() + VALUE(txt_SLA2__c) + FLOOR((VALUE(txt_SLA2__c))/5)*2, 
2, Today() + VALUE(txt_SLA2__c) + FLOOR((VALUE(txt_SLA2__c)+1)/5)*2, 
3, Today() + VALUE(txt_SLA2__c) + FLOOR((VALUE(txt_SLA2__c)+2)/5)*2, 
4, Today() + VALUE(txt_SLA2__c) + FLOOR((VALUE(txt_SLA2__c)+3)/5)*2, 
5, Today() + VALUE(txt_SLA2__c) + CEILING((VALUE(txt_SLA2__c))/5)*2, 
6, Today() - IF(VALUE(txt_SLA2__c)&gt;0,1,0) + VALUE(txt_SLA2__c) + CEILING((VALUE(txt_SLA2__c))/5)*2, 
null)),null)</formula>
        <name>CPA PWORF Submitted_SLA2 Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
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
        <fullName>CPA_PWORF_Submitted_date_null</fullName>
        <field>dat_Submitted_Date__c</field>
        <name>CPA PWORF Submitted date null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_VDM_group_mail</fullName>
        <field>eml_VDM_group_email__c</field>
        <formula>&quot;Demand.Unilever@accenture.com&quot;</formula>
        <name>CPA PWORF VDM group mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>CPA_PWORF_isAutoAccepted_true</fullName>
        <field>chk_isAutoAccepted__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF isAutoAccepted true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_isautoAccepted_false</fullName>
        <field>chk_isAutoAccepted__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWORF isautoAccepted false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_isresubmitted_false</fullName>
        <field>chk_isReSubmitted__c</field>
        <literalValue>0</literalValue>
        <name>CPA PWORF isresubmitted false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_isresubmitted_true</fullName>
        <field>chk_isReSubmitted__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF isresubmitted true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_no_of_SLA1_day_remaining</fullName>
        <field>num_Number_of_SLA1_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA1__c),(IF(OR( chk_isAccepted__c,chk_isAutoAccepted__c ),VALUE(txt_SLA1__c),IF(NOT(chk_isReSubmitted__c),(num_Number_of_SLA1_Days__c -((CASE(MOD( dat_Submitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Submitted_Date__c )/7)*5) )-1)),(num_Number_of_SLA1_Days__c -((CASE(MOD( dat_Resubmitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Resubmitted_Date__c )/7)*5) )-1))))), null)</formula>
        <name>CPA PWORF no of SLA1 day remaining</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_no_of_SLA2_day_remaining</fullName>
        <field>num_Number_of_SLA2_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA2__c ),(IF(OR( chk_isAccepted__c,chk_isAutoAccepted__c ),VALUE(txt_SLA2__c ),IF(NOT(chk_isReSubmitted__c),(num_Number_of_SLA2_Days__c -((CASE(MOD( dat_Submitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Submitted_Date__c )/7)*5) )-1)),(num_Number_of_SLA2_Days__c -((CASE(MOD( dat_Resubmitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Resubmitted_Date__c )/7)*5) )-1))))), null)</formula>
        <name>CPA PWORF no of SLA2 day remaining</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_retur_no_of_SLA2_day_remaining</fullName>
        <field>num_Number_of_SLA2_Days__c</field>
        <formula>IF(ISNUMBER(txt_SLA2__c ),(IF(NOT(chk_isReSubmitted__c),(num_Number_of_SLA2_Days__c -((CASE(MOD( dat_Submitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Submitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Submitted_Date__c )/7)*5) ) -1)),(num_Number_of_SLA2_Days__c -((CASE(MOD( dat_Resubmitted_Date__c - DATE(1985,6,24),7), 
0 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( TODAY() - dat_Resubmitted_Date__c ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TODAY() - dat_Resubmitted_Date__c )/7)*5) ) -1)))), null)</formula>
        <name>CPA PWORF retur no of SLA2 day remaining</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_return_SLA1_date_null</fullName>
        <field>dat_Expected_SLA1_Date__c</field>
        <name>CPA PWORF return SLA1 date null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_uniqueness</fullName>
        <field>Unique_PWORF__c</field>
        <formula>Name</formula>
        <name>CPA PWORF uniqueness</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_PWORF_withhold_isWithhold</fullName>
        <field>chk_isWithhold__c</field>
        <literalValue>1</literalValue>
        <name>CPA PWORF withhold isWithhold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
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
        <fullName>CPA_Reason_for_Cancellation</fullName>
        <field>ltxt_Reason_for_Cancellation__c</field>
        <name>CPA Reason for Cancellation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Resubmitted_Date_update</fullName>
        <description>Set Resubmitted date null</description>
        <field>dat_Resubmitted_Date__c</field>
        <name>CPA Resubmitted Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
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
        <fullName>CPA_Update_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>CAP_ULPM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CPA Update Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_isCancelled_PWORF_update</fullName>
        <description>mark ture when PWORF is Cancelled</description>
        <field>isCancelled_PWORF__c</field>
        <literalValue>1</literalValue>
        <name>CPA isCancelled PWORF update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_isCancelled_Pworf_update_fales</fullName>
        <description>to set isCancelled Pworf False PWORF is newly created</description>
        <field>isCancelled_PWORF__c</field>
        <literalValue>0</literalValue>
        <name>CPA isCancelled Pworf update fales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_isCancelled_Pworf_update_false</fullName>
        <description>to set isCancelled Pworf False PWORF is newly created</description>
        <field>isCancelled_PWORF__c</field>
        <literalValue>0</literalValue>
        <name>CPA isCancelled Pworf update false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_uncheck_IScancel</fullName>
        <field>isCancelled__c</field>
        <literalValue>0</literalValue>
        <name>CPA uncheck IScancel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_uncheck_Validate</fullName>
        <field>isValidated__c</field>
        <literalValue>0</literalValue>
        <name>CPA uncheck Validate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cancelled_Action_field_Udate</fullName>
        <description>PWORF is Cancelled.</description>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Cancelled&quot;</formula>
        <name>Cancelled Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resubmitted_Action_field_Udate</fullName>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Resubmitted successfully and waiting for Vendor&apos;s Approval.&quot;</formula>
        <name>Resubmitted Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Returned_Action_field_Udate</fullName>
        <description>PWORF is returned to Unilever PM</description>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is returned to Unilever PM&quot;</formula>
        <name>Returned Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Saved_Action_field_Udate</fullName>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is saved successfully and waiting for Unilever PM to submit it to vendor&quot;</formula>
        <name>Saved Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Withhold_Action_field_Udate</fullName>
        <field>txt_Action__c</field>
        <formula>&quot;PWORF is Withhold.&quot;</formula>
        <name>Withhold Action field Udate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
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
        <fullName>Approval Comment Flag for PWORF</fullName>
        <actions>
            <name>Approval_Comment_Requested_for_PWORF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Approval_Comment_Check__c</field>
            <operation>equals</operation>
            <value>Required</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Accepted</fullName>
        <actions>
            <name>CPA_PWORF_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Accepted_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Date_of_Acceptance_field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Accepted_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Accepted Updated</fullName>
        <actions>
            <name>CPA_PWORF_Accepted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Accepted_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Date_of_Acceptance_field_Update</name>
            <type>FieldUpdate</type>
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
        <criteriaItems>
            <field>CPA_PWORF__c.chk_isAutoAccepted__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Auto Accepted</fullName>
        <actions>
            <name>Update_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.chk_isAutoAccepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.chk_isAccepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
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
        <actions>
            <name>CPA_isCancelled_PWORF_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Cancelled_Action_field_Udate</name>
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
            <name>CPA_Date_of_Request_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Submitted_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Reason_for_Cancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Resubmitted_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_isCancelled_Pworf_update_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_uncheck_IScancel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <description>When PWORF is Cloned/Created, STATUS is set to Saved.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Cloned%2FCreated Updated New</fullName>
        <actions>
            <name>CPA_Date_of_Request_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Submitted_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Reason_for_Cancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Resubmitted_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_isCancelled_Pworf_update_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_uncheck_IScancel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Cloned%2FCreated Updated New v0%2E2</fullName>
        <actions>
            <name>CPA_PWORF_Revised_Submission_Date_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_SLA1_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_SLA2_Breach_Applicable_no</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_SLA2_Penalty_Applicable_no</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_SLA2_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_SMT_group_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_VDM_group_mail</name>
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
        <fullName>CPA PWORF Cloned%2FCreated updated</fullName>
        <actions>
            <name>CPA_Date_of_Request_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Date_of_Submission_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Submitted_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Reason_for_Cancellation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Resubmitted_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_isCancelled_Pworf_update_fales</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_isCancelled_Pworf_update_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_uncheck_IScancel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Saved_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>notEqual</operation>
            <value>Saved</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Resubmitted</fullName>
        <actions>
            <name>CPA_PWORF_Re_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_Re_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_isreturn_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_iswithhold_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_return_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_withhold_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_isresubmitted_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Resubmitted Updated</fullName>
        <actions>
            <name>CPA_PWORF_Re_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_Re_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_isreturn_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_iswithhold_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_return_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Resubmitted_withhold_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_isautoAccepted_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_isresubmitted_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Resubmitted</value>
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
            <name>CPA_PWORF_Retur_no_of_SLA1_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_Isreturn</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Returned_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_retur_no_of_SLA2_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Returned_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Returned Updated</fullName>
        <actions>
            <name>CPA_PWORF_Returned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Retur_no_of_SLA1_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_Isreturn</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Returned_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_retur_no_of_SLA2_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Returned_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Status update to Auto Accepted</fullName>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted,Resubmitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Expected_SLA1_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_Auto_Accepted_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Auto_Accepted_Action_field_Udate</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_PWORF_Auto_Accepted_Date_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_PWORF_isAutoAccepted_true</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA1_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPA PWORF Status update to Auto Accepted updated</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Expected_SLA1_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted,Resubmitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_Reminder_to_respond_to_PWORF_SLA1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA1_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_Auto_Accepted_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Auto_Accepted_Action_field_Udate</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_PWORF_Auto_Accepted_Date_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_PWORF_isAutoAccepted_true</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA1_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPA PWORF Withhold</fullName>
        <actions>
            <name>CPA_PWORF_Withhold_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_Withhold_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_no_of_SLA1_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_no_of_SLA2_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_withhold_isWithhold</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Withhold_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Withhold</value>
        </criteriaItems>
        <description>This workflow will fire after the status for PWORF will be Withhold update the date fields.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Withhold Updated</fullName>
        <actions>
            <name>CPA_PWORF_Withhold_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CAP_PWORF_Withhold_Withhold_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_Return_SLA2_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_no_of_SLA1_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_no_of_SLA2_day_remaining</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_return_SLA1_date_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_PWORF_withhold_isWithhold</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Withhold_Action_field_Udate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Withhold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Withhold Updated v0%2E1</fullName>
        <actions>
            <name>CAP_Owner_Update_to_ULPM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Withhold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF reminder for Clarity ID</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.txt_Clarity_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_reminder_for_Clarity_ID</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPA PWORF submitted</fullName>
        <actions>
            <name>CPA_PWORF_Submitted_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
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
        <fullName>CPA PWORF uniqueness</fullName>
        <actions>
            <name>CPA_PWORF_uniqueness</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR((IF( AND(NOT(ISNEW()) , ISCHANGED(  Name  )) , true,false)),(IF( AND(ISNEW() , NOT(ISBLANK(Name  ))) , true,false)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA SLA2 BreachCheck</fullName>
        <active>false</active>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Expected_SLA2_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Accepted,Auto Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_Breach_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_Penalty_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA2_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPA SLA2 BreachCheck Updated</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Expected_SLA2_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted,Resubmitted,Auto Accepted,Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Revised_Submission_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_Breach_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_Penalty_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA2_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_Reminder_to_submit_PWO_SLA2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Expected_SLA2_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CPA SLA2 BreachCheck Updated v0%2E1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>CPA_PWORF__c.dat_Revised_Submission_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CPA_PWORF__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Submitted,Resubmitted,Auto Accepted,Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_Breach_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>CPA_Penalty_Applicable</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Revised_Submission_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CPA_PWORF_Reminder_to_submit_PWO_SLA2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CPA_PWORF__c.dat_Revised_Submission_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
