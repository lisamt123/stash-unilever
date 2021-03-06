<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AF_Agency_Rejection</fullName>
        <description>AF_Agency_Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>AF_AgencyUsers10__c</field>
            <type>email</type>
        </recipients>
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
        <recipients>
            <field>AF_AgencyUsers6__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers7__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers8__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers9__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_AgencyRejection_HTML</template>
    </alerts>
    <alerts>
        <fullName>AF_Agency_Submission</fullName>
        <description>Agency Submission</description>
        <protected>false</protected>
        <recipients>
            <field>AF_Cat_Finance_Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_AgencySubmission_HTML</template>
    </alerts>
    <alerts>
        <fullName>AF_Controller_Rejects_the_Record</fullName>
        <description>Controller Rejects the Record</description>
        <protected>false</protected>
        <recipients>
            <field>AF_Cat_Finance_Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_CategoryFinance_Rejection_HTML</template>
    </alerts>
    <alerts>
        <fullName>AF_Email_Notification_to_Agency_users_re_target_base_fees</fullName>
        <description>Email Notification to Agency users re target base fees</description>
        <protected>false</protected>
        <recipients>
            <field>AF_AgencyUsers10__c</field>
            <type>email</type>
        </recipients>
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
        <recipients>
            <field>AF_AgencyUsers6__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers7__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers8__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>AF_AgencyUsers9__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_Notification_Agency_HTML</template>
    </alerts>
    <alerts>
        <fullName>CMCO_Rejection</fullName>
        <description>AF CMCO Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>AF_Cat_Finance_Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_CMCO_Rejection_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_to_Cat_Finance_Users</fullName>
        <description>Email Notification to Cat Finance Users</description>
        <protected>false</protected>
        <recipients>
            <field>AF_Cat_Finance_Approver_10__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_4__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_5__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_6__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_7__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_8__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>AF_Cat_Finance_Approver_9__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/AF_CMCO_Approval_HTML</template>
    </alerts>
    <alerts>
        <fullName>Sending_email_adjust_quarter</fullName>
        <description>Sending_email</description>
        <protected>false</protected>
        <recipients>
            <field>UserEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Agency_Fees/Sending_email_adjust_quarter_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>AF_AgencyRejection</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With Agency</literalValue>
        <name>AF_AgencyRejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_AgencySubmission</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With Category Finance</literalValue>
        <name>AF_AgencySubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Agency_Field_to_be_Updated</fullName>
        <field>AF_Agency_Sharing__c</field>
        <formula>AF_Agency__r.Name</formula>
        <name>Agency Field to be Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_ApprovalRejection</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With Category Finance</literalValue>
        <name>ApprovalRejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_ApprovalUpdate</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With CMCO</literalValue>
        <name>AF_ApprovalUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_CMCO_Rejected</fullName>
        <field>AF_CMCO_Rejected__c</field>
        <literalValue>1</literalValue>
        <name>CMCO Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_CatFinance_Approved</fullName>
        <field>AF_Category_Finance_Approved__c</field>
        <literalValue>0</literalValue>
        <name>CatFinance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Controller_Rejection</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With Category Finance</literalValue>
        <name>Controller Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Set_isFirstTime_to_False</fullName>
        <field>AF_isFirsttime__c</field>
        <literalValue>0</literalValue>
        <name>Set isFirstTime to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Status_Update</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With CMCO</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AF_Update_BaseFeeStatusChangedTime</fullName>
        <field>AF_BaseFeeStatusChangedTime__c</field>
        <formula>now()</formula>
        <name>Update BaseFeeStatusChangedTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AUpdate_Brand_Estimate_Initiate_to_False</fullName>
        <field>Initiated__c</field>
        <literalValue>0</literalValue>
        <name>Update Brand Estimate Initiate to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CMCO_Rejected_False</fullName>
        <field>AF_CMCO_Rejected__c</field>
        <literalValue>0</literalValue>
        <name>CMCO Rejected - False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CatFinance_Approved</fullName>
        <field>AF_Category_Finance_Approved__c</field>
        <literalValue>1</literalValue>
        <name>CatFinance Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsUpdate_False</fullName>
        <field>IsUpdate__c</field>
        <literalValue>0</literalValue>
        <name>IsUpdate_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NotifiedAgency</fullName>
        <field>AF_Notified_to_Agency__c</field>
        <literalValue>1</literalValue>
        <name>NotifiedAgency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Review_Update</fullName>
        <field>AF_Category_Finance_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Review Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Brand_Estimate_when_Ready_for_PO</fullName>
        <field>AF_When_changed_to_Ready_fo_PO__c</field>
        <formula>TODAY()</formula>
        <name>Update Brand Estimate when Ready for PO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Name_for_Migration</fullName>
        <field>Brand_Estimate_Name_Migration__c</field>
        <formula>Name</formula>
        <name>Update Name for Migration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>Ready for PO</literalValue>
        <name>Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_With_Agency</fullName>
        <field>AF_Status_Base_Fees__c</field>
        <literalValue>With Agency</literalValue>
        <name>Update to With Agency</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AF_Email Notification to Agency users re target base fees</fullName>
        <active>true</active>
        <criteriaItems>
            <field>AF_Brand_Estimate__c.AF_Notified_to_Agency__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AF_Email_Notification_to_Agency_users_re_target_base_fees</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AF_Brand_Estimate__c.Trigger_Time_05__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AF_Populate Agency for Sharing</fullName>
        <actions>
            <name>AF_Agency_Field_to_be_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Brand_Estimate__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Change Initiate to With Agency</fullName>
        <actions>
            <name>AUpdate_Brand_Estimate_Initiate_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NotifiedAgency</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_With_Agency</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AF_Brand_Estimate__c.Base_Fee_Total__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_Brand_Estimate__c.Initiated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>AF_Brand_Estimate__c.AF_Status_Base_Fees__c</field>
            <operation>equals</operation>
            <value>Initiate</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Sending email for adjust quarter</fullName>
        <actions>
            <name>Sending_email_adjust_quarter</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>IsUpdate_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(AF_Basefee_Estimate_Initial_Quarter__c)  &amp;&amp;  IsUpdate__c = True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Name for Migration</fullName>
        <actions>
            <name>Update_Name_for_Migration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update isFirstTime</fullName>
        <actions>
            <name>AF_Set_isFirstTime_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AF_isFirsttime__c  &amp;&amp; NOT(INCLUDES( AF_Basefee_Estimate_Initial_Quarter__c , &apos;Q1&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
