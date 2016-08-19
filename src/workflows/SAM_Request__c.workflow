<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Quote_Resubmitted_With_Modification</fullName>
        <description>Quote Resubmitted After Requester asking for Modification in Quote</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_FinalQuoteReSubmitted_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>Requester_Submits_the_Query</fullName>
        <description>Requester Submits the Query</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestOpen_To_Admin</template>
    </alerts>
    <alerts>
        <fullName>SAM_AdditionalCCDetailsProvided_ToULFTBySAMT</fullName>
        <description>SAM Team Provides Additional CC details to ULFT</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_Submits_Missing_Finance_Info_To_ULFT</template>
    </alerts>
    <alerts>
        <fullName>SAM_AdditionalCCdetails_RequestFromULFT_To_SAMT</fullName>
        <description>Finance Team Requests SAM Team  For Additional CC details</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_AwaitingAdditionalFinanceDetails_By_ULFT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Additional_CC_Dtails_FromRequester_ToSAMTeam</fullName>
        <description>Requester Provides additional CC Details To SAM Team</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_AdditionalCCDetailsProvided_From_Requester_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Admin_assigns_the_Query</fullName>
        <description>SAM Admin assigns the Query</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestAssigned_To_SAM_Member</template>
    </alerts>
    <alerts>
        <fullName>SAM_Awaiting_Information_from_requester</fullName>
        <description>SAM Awaiting Information from requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_More_Info_Required_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_Build_Details_Required_From_SAMT_To_Requester</fullName>
        <description>SAM Team asks for build/do/run cost details</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_DetailsRequired_DO_Build_From_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Close_After_CrossCharge_Complete</fullName>
        <description>ULSAMT closes the request After CrossCharge completed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QueryClosed_By_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Close_After_NobuildRequired_NoSoftwareSpend</fullName>
        <description>ULSAMT selects No Software Spend .No build Details required</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_NoSoftwareSpend_Closed</template>
    </alerts>
    <alerts>
        <fullName>SAM_CossCharge_Rejected_By_Finance_Team</fullName>
        <description>Finance team Rejects The Cross Charge</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_CCRejected_From_ULFT_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_CrossCharge_Completed_By_ULFT</fullName>
        <description>Finance Team Completes The Cross Charge</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_CCApproved_By_ULFT_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_DetailsPending_To_Requester</fullName>
        <description>SAM Team Requests For  details(DO/Run-Cost/Build) to Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_DetailsRequired_DO_Build_From_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Details_Pending_After_NoSoftwareSpend_To_Requester</fullName>
        <description>ULSAMT selects No Software Spend -Details_Pending</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_DetailsRequired_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_Draft_Quote_By_SAM_Team</fullName>
        <description>SAM Team Provides the Draft  Quote To Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_DraftQuote_By_SAMT_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_FinalQuote_Resubmitted_After_Modification</fullName>
        <description>ULSAMT Provides Modified Quote</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_FinalQuoteReSubmitted_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_Final_Quote_To_Requester_By_SAMTeam</fullName>
        <description>SAM Team provides The Final Quote To Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_FinalQuoteProvided_By_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Invalid_Req_Closed_By_SAMTeamMember</fullName>
        <description>SAM Team member Rejects the Invalid Request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QueryClosed_By_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Missing_Info_Provided_By_Requester</fullName>
        <description>Requester Provides the Missing Info To SAM Team Member</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_MissingInfoProvided_To_SAMT_From_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_More_CC_Details_Needed_fromSAMT_ToRequester</fullName>
        <description>SAM Team request more CC information from Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_AdditionalChargingDetailsNeeded_To_Requester_From_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_QuoteApproved_By_Requester</fullName>
        <description>Requester Approves the Quote</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QuoteApproved_By_Requester_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Quote_Rejected_by_Requester</fullName>
        <description>Quote Rejected by The Requester</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QuoteRejected_To_SAMT_From_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_Reassign_Req_To_New_SAMTeamMember</fullName>
        <description>SAM Admin Reassigns the Request to  new SAM team member</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestReassigned</template>
    </alerts>
    <alerts>
        <fullName>SAM_Req_Accepted_By_SAMTeamMember</fullName>
        <description>SAM Team Member Accepts the request</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/RequestAccepted_By_SAM_Team_Member_To_SAMAdmin</template>
    </alerts>
    <alerts>
        <fullName>SAM_Request_AssignedTo_SAM_Member</fullName>
        <description>Request (Project,Non Project ,Query) Assigned to SAM Team member</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestOpen_To_Admin</template>
    </alerts>
    <alerts>
        <fullName>SAM_Request_for_CrossCharge_BySAMT_To_Finance_Team</fullName>
        <description>SAMTeam sends the request for cross Charge to Finance Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_SumbitsForFinanceCharge_To_ULFT</template>
    </alerts>
    <alerts>
        <fullName>SAM_Request_submitted</fullName>
        <description>Request (Project,Non Project ,Query) submitted to SAM Admin</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestOpen_To_Admin</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULEMP_resubmits_the_query</fullName>
        <description>ULEMP resubmits the query</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QueryResubmitted</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULFT_completes_the_Cross_Charge</fullName>
        <description>ULFT completes the Cross Charge</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_CCApproved_By_ULFT_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULFT_rejects_CC_request</fullName>
        <description>ULFT rejects CC request</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Finance_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_CCRejected_From_ULFT_To_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULSADM_reassigns_the_Query</fullName>
        <description>SAM ULSADM reassigns the Query</description>
        <protected>false</protected>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_RequestReassigned</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULSAMT_Answers_the_Query</fullName>
        <description>ULSAMT Answers the Query</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QuerryAnswered_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULSAMT_closes_the_Request</fullName>
        <description>ULSAMT closes the Request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QueryClosed_By_SAMT</template>
    </alerts>
    <alerts>
        <fullName>SAM_ULSEMP_closes_Query_request</fullName>
        <description>ULSEMP closes Query request</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>SAM_Admin</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>SAM_Team</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <field>lkp_Assign_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SAM_Email_Template_Folder/SAM_QueryClosed_By_SAMT</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Record_Type_to_SAM_RW_Project_Req</fullName>
        <description>Change the record type to ReSubmit_Project ( earlier SAM_RW_Project_Req)</description>
        <field>RecordTypeId</field>
        <lookupValue>ReSubmit_Project</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record Type to ReSubmit_Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>End_Date_update</fullName>
        <field>date_Request_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM End Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_SAM_Project_Finance_On_Awaiting_Charg</fullName>
        <description>Change the project record type to  SAM_Project_Finance_On_Awaiting_Charg</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_Finance_On_Awaiting_Charge</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RT SAM_Project_Finance_On_Awaiting_Charg</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordType_SAM_Project_RW_Req_Quote_Prov</fullName>
        <description>Sets the Project request record type to SAM_Project_RW_Req_Quote_Provided</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_RW_Req_Quote_Provided</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordType SAM_Project_RW_Req_Quote_Prov</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Cross_Charge_Completion_Date_Update</fullName>
        <description>Report - Cross Charge Completion Date Update when status is Charging completed</description>
        <field>date_Cross_Charge_Completion_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM Cross Charge Completion Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Finance_Submission_Date_Update</fullName>
        <description>Report - update Finance submission date when status is awaiting charge</description>
        <field>date_Finance_Submission_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM Finance Submission Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_NP_record_type_update_to_OnHold</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Non_Project_RW_SAM_Team_On_hold</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM NP record type update to OnHold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Project_record_type_update_to_OnHold</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_RW_SAM_Team_On_hold</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Project record type update to OnHold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Quote_provide_Date_Update</fullName>
        <field>Quote_Final_Provided_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM Quote provide Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_RT_SAM_CC_Req_Fin_Queue</fullName>
        <description>Set the Cross Charge request type to SAM_Cross_Charge_Request_Finance_Awaiting_Charge_Queue</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Cross_Charge_Request_Finance_Awaiting_Charge_Queue</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM RT SAM_CC_Req_Fin_Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_RT_SAM_Cross_Charge_Request_Closed</fullName>
        <description>Set the record type to SAM_Cross_Charge_Request_Closed</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Cross_Charge_Request_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM RT SAM_Cross_Charge_Request_Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_RT_SAM_Cross_Charge_Request_Finance</fullName>
        <description>Set Record Type to SAM_Cross_Charge_Request_Finance</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Cross_Charge_Request_Finance</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM RT SAM_Cross_Charge_Request_Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_RT_SAM_RW_CrossCharge_Request</fullName>
        <description>Sets the CrossCharge Request Record Type to ReSubmit_Cross_Charge ( earlier it was SAM_RW_CrossCharge_Request )</description>
        <field>RecordTypeId</field>
        <lookupValue>ReSubmit_Cross_Charge</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM RT ReSubmit_Cross_Charge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Record_type_display_on_UI</fullName>
        <field>txt_Request_Type_for_UI__c</field>
        <formula>RecordType.Name</formula>
        <name>SAM Record type display on UI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Reset_Finance_Picklist</fullName>
        <field>pkl_SAM_Finance_Status__c</field>
        <name>Reset Finance Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Reset_Requester_Picklist</fullName>
        <description>Resets the Next</description>
        <field>pkl_SAM_Requester_Status__c</field>
        <name>Reset Requester Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Reset_SAM_Picklist</fullName>
        <field>pkl_SAM_team_Status__c</field>
        <name>Reset SAM Picklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_Charge_Complete_Layout</fullName>
        <description>Set the record type to SAM_Cross_Charge_Request_Complete</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Cross_Charge_Request_Complete</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Set Charge Complete Layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_Proj_Finance_OnAwaitingCharge_Q</fullName>
        <description>Set the record type to SAM_Project_Finance_On_Awaiting_Charge_Queue</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_Finance_On_Awaiting_Charge_Queue</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Set Proj Finance OnAwaitingCharge Q</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_Query_End_Date</fullName>
        <field>date_Query_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM Set Query End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_Query_Start_Date</fullName>
        <description>Sets the date_Query_Start_Date__c to submit date of the query</description>
        <field>date_Query_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>SAM Set Query Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_STATUS_to_Saved</fullName>
        <description>Set the STATUS field of a request to Saved</description>
        <field>pkl_Status__c</field>
        <literalValue>Saved</literalValue>
        <name>Set STATUS to Saved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Set_owner_to_SAM_Finance_Queue</fullName>
        <description>Sets the owner of the request to SAM Finance queue</description>
        <field>OwnerId</field>
        <lookupValue>SAM_Finance_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAM Set owner to SAM Finance Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Update_Report_Request_Status</fullName>
        <field>pkl_Ownership_Reporting__c</field>
        <literalValue>Draft-Save</literalValue>
        <name>SAM Update Report Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_record_type_update</fullName>
        <field>txt_Request_Type__c</field>
        <formula>RecordType.DeveloperName</formula>
        <name>SAM record type update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Is_Charging_Submitted_Once_to_True</fullName>
        <field>chk_Is_Charging_Submitted_Once__c</field>
        <literalValue>1</literalValue>
        <name>Set Is Charging Submitted Once to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Non_Project_Close</fullName>
        <description>Sets the Request record type to SAM_Non_Project_Close</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Non_Project_Close</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Non_Project_Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Non_Project_RW_Req_Quote_Prov</fullName>
        <description>Sets the Record Type to SAM_Non_Project_RW_Req_Quote_Provided</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Non_Project_RW_Req_Quote_Provided</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Non_Project_RW_Req_Quote_Prov</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Non_Project_RW_SAM_Team</fullName>
        <description>Sets the record type to SAM_Non_Project_RW_SAM_Team</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Non_Project_RW_SAM_Team</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Non_Project_RW_SAM_Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Query_Request_Answered</fullName>
        <description>Set the Request record type to SAM_Query_Request_Answered</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Query_Request_Answered</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Query_Request_Answered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Query_Request_Closed</fullName>
        <description>Set the Record Type to SAM_Query_Request_Closed</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Query_Request_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Query_Request_Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_Query_Request_SAM_team</fullName>
        <description>Set the Record type to SAM_Query_Request_SAM_team</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Query_Request_SAM_team</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT SAM_Query_Request_SAM_team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_SAM_RW_Non_Project_Request</fullName>
        <description>Sets the record type to ReSubmit_Non_Project ( earlier SAM_RW_Non_Project_Request )</description>
        <field>RecordTypeId</field>
        <lookupValue>ReSubmit_Non_Project</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RT ReSubmit_Non_Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RecordType_SAM_Project_Close</fullName>
        <description>Sets the Project request to SAM_Project_Close record type</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_Close</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RecordType SAM_Project_Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RecordType_SAM_Project_RW_SAM_Team</fullName>
        <description>Sets the record type to SAM_Project_RW_SAM_Team</description>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Project_RW_SAM_Team</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set RecordType SAM_Project_RW_SAM_Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_SAM_Admin_Queue</fullName>
        <description>Updates the SAM Request owner to SAM Admin Queue</description>
        <field>OwnerId</field>
        <lookupValue>SAM_Admin_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to SAM Admin Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Start_Date</fullName>
        <field>date_Request_Start_Date__c</field>
        <formula>CreatedDate</formula>
        <name>SAM Update Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SAM Cross Charge Completion Date Update</fullName>
        <actions>
            <name>SAM_Cross_Charge_Completion_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Charging Completed</value>
        </criteriaItems>
        <description>Report - Cross Charge Completion Date Update when status is Charging Completed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Finance Submission Date Update</fullName>
        <actions>
            <name>SAM_Finance_Submission_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <description>Report - Update Finance Submission Date when status is Awaiting Charge</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Quote Provided Date Update</fullName>
        <actions>
            <name>SAM_Quote_provide_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Quote Provided</value>
        </criteriaItems>
        <description>Report - Need to update date when status will be Quote provided</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Request End Date Update</fullName>
        <actions>
            <name>End_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Report - end date update</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Request start Date Update</fullName>
        <actions>
            <name>Update_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Saved</value>
        </criteriaItems>
        <description>Report - request start date update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAM Set Query End Date</fullName>
        <actions>
            <name>SAM_Set_Query_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Query_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.date_Query_End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>For Query requests by Requester ,set end date to close date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Set STATUS to Saved</fullName>
        <actions>
            <name>SAM_Record_type_display_on_UI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAM_Set_STATUS_to_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAM_Update_Report_Request_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAM_record_type_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the STATUS of new created request to Saved</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAM Set owner to SAM Admin Queue %2CSend Submit emails and Set StartDate</fullName>
        <actions>
            <name>SAM_Request_submitted</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SAM_Set_Query_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_SAM_Admin_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR (3 AND 4))</booleanFilter>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Project,Non Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Query</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.ltxt_User_Public_Groups__c</field>
            <operation>notContain</operation>
            <value>SAM_Team</value>
        </criteriaItems>
        <description>Sets the owner of the submitted Project and Non-Project request to SAM Admin queue if the requester does not belong to the SAM Team public group and sends Submit email and sets the start date of the request</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Set owner to SAM Finance Queue and Send Re-Submit CC email</fullName>
        <actions>
            <name>SAM_AdditionalCCDetailsProvided_ToULFTBySAMT</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SAM_Set_owner_to_SAM_Finance_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.chk_Is_Charging_Submitted_Once__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the owner of the submitted project/Cross Charge request to SAM Finance queue and send resubmit CC email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Set owner to SAM Finance Queue and Send Submit CC email</fullName>
        <actions>
            <name>SAM_Request_for_CrossCharge_BySAMT_To_Finance_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SAM_Set_owner_to_SAM_Finance_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Is_Charging_Submitted_Once_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.chk_Is_Charging_Submitted_Once__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sets the owner of the submitted project/Cross Charge request to SAM Finance queue and sends CC submit email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To ReSubmit_Cross_Charge</fullName>
        <actions>
            <name>SAM_RT_SAM_RW_CrossCharge_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_CrossCharge_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Charging Rejected,Awaiting CC details (Pending with ULSMT)</value>
        </criteriaItems>
        <description>Update the CrossCharge Request Record Type to ReSubmit_Cross_Charge</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To ReSubmit_Non_Project</fullName>
        <actions>
            <name>Set_RT_SAM_RW_Non_Project_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Non_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <description>Update the Request record type to ReSubmit_Non_Project</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To ReSubmit_Project</fullName>
        <actions>
            <name>Change_Record_Type_to_SAM_RW_Project_Req</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Cross_Charge_Request_Closed</fullName>
        <actions>
            <name>SAM_RT_SAM_Cross_Charge_Request_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_CrossCharge_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Update Record Type to SAM_Cross_Charge_Request_Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Cross_Charge_Request_Complete</fullName>
        <actions>
            <name>SAM_Set_Charge_Complete_Layout</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_CrossCharge_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Charging Completed</value>
        </criteriaItems>
        <description>Update Record Type to SAM_Cross_Charge_Request_Complete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Cross_Charge_Request_Finance</fullName>
        <actions>
            <name>SAM_RT_SAM_Cross_Charge_Request_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_CrossCharge_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Open,Charging In Progress</value>
        </criteriaItems>
        <description>Update the CrossCharge Request Record Type to SAM_Cross_Charge_Request_Finance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Cross_Charge_Request_Finance_Awaiting_Charge_Queue</fullName>
        <actions>
            <name>SAM_RT_SAM_CC_Req_Fin_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_CrossCharge_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <description>Update the CrossCharge Request Record Type to SAM_Cross_Charge_Request_Finance_Awaiting_Charge_Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Non_Project_Close</fullName>
        <actions>
            <name>Set_RT_SAM_Non_Project_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Non_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Update the Request record type to SAM_Non_Project_Close</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Non_Project_RW_Req_Quote_Provided</fullName>
        <actions>
            <name>Set_RT_SAM_Non_Project_RW_Req_Quote_Prov</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Non_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Quote Provided,Quote Approved</value>
        </criteriaItems>
        <description>Update the Request record type to SAM_Non_Project_RW_Req_Quote_Provided</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Non_Project_RW_SAM_Team</fullName>
        <actions>
            <name>Set_RT_SAM_Non_Project_RW_SAM_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Non_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Open,In Progress,Information Provided,Draft Quote Provided,Quote Rejected</value>
        </criteriaItems>
        <description>Update the Request record type to SAM_Non_Project_RW_SAM_Team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Non_Project_RW_SAM_Team_On_hold</fullName>
        <actions>
            <name>SAM_NP_record_type_update_to_OnHold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Non_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>Update the Request record type to SAM_Non_Project_RW_SAM_Team_on_hold</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_Close</fullName>
        <actions>
            <name>Set_RecordType_SAM_Project_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Updates the Project Request record type to SAM_Project_Close</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_Finance_On_Awaiting_Charge</fullName>
        <actions>
            <name>RT_SAM_Project_Finance_On_Awaiting_Charg</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Charging In Progress,Charging Completed</value>
        </criteriaItems>
        <description>Updates the Project Request record type to SAM_Project_Finance_On_Awaiting_Charge</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_Finance_On_Awaiting_Charge_Queue</fullName>
        <actions>
            <name>SAM_Set_Proj_Finance_OnAwaitingCharge_Q</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <description>Updates the Project Request record type toSAM_Project_Finance_On_Awaiting_Charge_Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_RW_Req_Quote_Provided</fullName>
        <actions>
            <name>RecordType_SAM_Project_RW_Req_Quote_Prov</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Quote Provided,Quote Approved,Quote Rejected,Awaiting CC details (Pending with ULEMP),CC details provided (By ULEMP),Charging Rejected,Awaiting CC details (Pending with ULSMT)</value>
        </criteriaItems>
        <description>Updates the Project Request record type to SAM_Project_RW_Req_Quote_Provided</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_RW_SAM_Team</fullName>
        <actions>
            <name>Set_RecordType_SAM_Project_RW_SAM_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Open,In Progress,Draft Quote Provided,Information Provided</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Project_RW_SAM_Team_On_hold</fullName>
        <actions>
            <name>SAM_Project_record_type_update_to_OnHold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Project_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Query_Request_Answered</fullName>
        <actions>
            <name>Set_RT_SAM_Query_Request_Answered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Query_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Query Answered</value>
        </criteriaItems>
        <description>Update the CrossCharge Request Record Type to SAM_Query_Request_Answered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Query_Request_Closed</fullName>
        <actions>
            <name>Set_RT_SAM_Query_Request_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Query_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Update the Request Record Type to SAM_Query_Request_Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Update Record Type To SAM_Query_Request_SAM_team</fullName>
        <actions>
            <name>Set_RT_SAM_Query_Request_SAM_team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request__c.txt_Request_Type__c</field>
            <operation>equals</operation>
            <value>SAM_RW_Query_Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request__c.pkl_Status__c</field>
            <operation>equals</operation>
            <value>Open,In Progress,Answer Accepted,Need More Info</value>
        </criteriaItems>
        <description>Update the Query Request Record Type to SAM_Query_Request_SAM_team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
