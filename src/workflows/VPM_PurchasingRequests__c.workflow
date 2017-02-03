<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
	<alerts>
        <fullName>VPM_RequestforUsertoCompleteVendorRequestSurvey</fullName>
        <description>Request for User to Complete Vendor Request Survey</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_UserSurveyRequest</template>
    </alerts>
    <alerts>
        <fullName>VPM_RequestRejectMDMNotification</fullName>
        <description>VPM - Used to send Notification to the MDM Ops  when the request is rejected</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_MDMOpsEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_SAPBPMRejected</template>
    </alerts>
    <alerts>
        <fullName>VPM_SendEmailToVendorEmail</fullName>
        <description>VPM Send email to Vendor Email</description>
        <protected>false</protected>
        <recipients>
            <field>VPM_VendorContactDetail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_RequestVendorDetails</template>
    </alerts>
    <fieldUpdates>
        <fullName>VPM_ApprovedByBankValidationEmail</fullName>
        <description>VPM - captures the email of bank Validation Approver.</description>
        <field>VPM_BankValidationApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By Bank Validation Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFLSEmail</fullName>
        <description>VPM - captures the email of FLS approver.</description>
        <field>VPM_FLSApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By FLS Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFinanceEmail</fullName>
        <description>VPM - captures the emial of approver user.</description>
        <field>VPM_FinanceApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM - Approved By Finance Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByFreightEmail</fullName>
        <description>VPM - captures the email of freight approver.</description>
        <field>VPM_FreightApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Freight Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByMasterDataEmail</fullName>
        <description>VPM- captures the email of Master data approver.</description>
        <field>VPM_MasterDataApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Master Data Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByProcurementEmail</fullName>
        <description>VPM - captures the email of approved by User</description>
        <field>VPM_ProcurementApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Procurement Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ApprovedByRussianEmail</fullName>
        <description>VPM - Captures the approver email.</description>
        <field>VPM_RussainCustomTaxApprovedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Approved By Russian Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_ChangeStatusMDMApproved</fullName>
        <description>VPM  -  Set the status as Local MDM Approved</description>
        <field>VPM_Status__c</field>
        <literalValue>Master Data Management Approved</literalValue>
        <name>VPM - Change Status MDM Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_MDMSubmittedYes</fullName>
        <description>VPM - Set the flag as &quot;Yes&quot; the Local MDM submitted the request</description>
        <field>VPM_MasterDataManagementSubmitted__c</field>
        <literalValue>Yes</literalValue>
        <name>VPM - MDM Submitted Yes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_MasterDataManagementApprovedTime</fullName>
        <description>VPM- Time the Request is Approved by the group.</description>
        <field>VPM_MasterDataManagementApproval__c</field>
        <formula>NOW()</formula>
        <name>Master Data Management Approved Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RegionForWFR12</fullName>
        <description>Updates the &apos;Reporting Region&apos; field with the value of one of the following Europe, North America, Latin America, South East Asia &amp; Australia, Africa</description>
        <field>VPM_ReportingRegion__c</field>
        <formula>CASE(VPM_CountryRequestingVendor__c,
	&quot;Austria&quot;,&quot;Europe&quot;,
	&quot;Belgium&quot;,&quot;Europe&quot;,
	&quot;Bulgaria&quot;,&quot;Europe&quot;,
	&quot;Czech Republic&quot;,&quot;Europe&quot;,
	&quot;Denmark&quot;,&quot;Europe&quot;,
	&quot;Estonia&quot;,&quot;Europe&quot;,
	&quot;Finland&quot;,&quot;Europe&quot;,
	&quot;France&quot;,&quot;Europe&quot;,
	&quot;Greece&quot;,&quot;Europe&quot;,
	&quot;Hungary&quot;,&quot;Europe&quot;,
	&quot;Ireland&quot;,&quot;Europe&quot;,
	&quot;Italy&quot;,&quot;Europe&quot;,
	&quot;Netherlands&quot;,&quot;Europe&quot;,
	&quot;Norway&quot;,&quot;Europe&quot;,
	&quot;Poland&quot;,&quot;Europe&quot;,
	&quot;Romania&quot;,&quot;Europe&quot;,
	&quot;Serbia&quot;,&quot;Europe&quot;,
	&quot;Slovakia&quot;,&quot;Europe&quot;,
	&quot;Spain&quot;,&quot;Europe&quot;,
	&quot;Switzerland&quot;,&quot;Europe&quot;,
	&quot;Sweden&quot;,&quot;Europe&quot;,
	&quot;United Kingdom&quot;,&quot;Europe&quot;,
	&quot;USA&quot;,&quot;North America&quot;,
	&quot;Canada&quot;,&quot;North America&quot;,
	&quot;Peru&quot;,&quot;Latin America&quot;,
	&quot;Brazil&quot;,&quot;Latin America&quot;,
	&quot;Mexico&quot;,&quot;Latin America&quot;,
	&quot;El Salvador&quot;,&quot;Latin America&quot;,
	&quot;Guatemala&quot;,&quot;Latin America&quot;,
	&quot;Colombia&quot;,&quot;Latin America&quot;,
	&quot;Ecuador&quot;,&quot;Latin America&quot;,
	&quot;Dominican Rep.&quot;,&quot;Latin America&quot;,
	&quot;Argentina&quot;,&quot;Latin America&quot;,
	&quot;Nicaragua&quot;,&quot;Latin America&quot;,
	&quot;Trinidad,Tobago&quot;,&quot;Latin America&quot;,
	&quot;Costa Rica&quot;,&quot;Latin America&quot;,
	&quot;Honduras&quot;,&quot;Latin America&quot;,
	&quot;Venezuela&quot;,&quot;Latin America&quot;,
	&quot;Chile&quot;,&quot;Latin America&quot;,
	&quot;Paraguay&quot;,&quot;Latin America&quot;,
	&quot;Panama&quot;,&quot;Latin America&quot;,
	&quot;Uruguay&quot;,&quot;Latin America&quot;,
	&quot;Thailand&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Australia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Singapore&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Myanmar&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Philippines&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Indonesia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;New Zealand&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Vietnam&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Cambodia&quot;,&quot;South East Asia &amp; Australia&quot;,
	&quot;Zambia&quot;,&quot;Africa&quot;,
	&quot;Kenya&quot;,&quot;Africa&quot;,
	&quot;Malawi&quot;,&quot;Africa&quot;,
	&quot;Uganda&quot;,&quot;Africa&quot;,
	&quot;Zimbabwe&quot;,&quot;Africa&quot;,
	&quot;Ivory Coast&quot;,&quot;Africa&quot;,
	&quot;Nigeria&quot;,&quot;Africa&quot;,
	&quot;Mozambique&quot;,&quot;Africa&quot;,
	&quot;South Africa&quot;,&quot;Africa&quot;,
	&quot;Ghana&quot;,&quot;Africa&quot;,
	&quot;Ethiopia&quot;,&quot;Africa&quot;,
	&quot;Tanzania&quot;,&quot;Africa&quot;, 
	&quot;Dijbouti&quot;,&quot;Africa&quot;,

NULL)</formula>
        <name>Region for WFR 1/2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RegionForWFR22</fullName>
        <description>Updates the &apos;Reporting Region&apos; field with the value of one of the following South Asia, North Asia, NAMET RUB, Fusion</description>
        <field>VPM_ReportingRegion__c</field>
        <formula>CASE(VPM_CountryRequestingVendor__c, 
&quot;Pakistan&quot;,&quot;South Asia&quot;, 
&quot;Bangladesh&quot;,&quot;South Asia&quot;, 
&quot;China&quot;,&quot;South Asia&quot;, 
&quot;Japan&quot;,&quot;South Asia&quot;, 
&quot;Taiwan&quot;,&quot;South Asia&quot;, 
&quot;Hong Kong&quot;,&quot;South Asia&quot;, 
&quot;Iran&quot;,&quot;NAMET RUB&quot;, 
&quot;Algeria&quot;,&quot;NAMET RUB&quot;, 
&quot;Egypt&quot;,&quot;NAMET RUB&quot;, 
&quot;Saudi Arabia&quot;,&quot;NAMET RUB&quot;, 
&quot;Tunisia&quot;,&quot;NAMET RUB&quot;, 
&quot;Utd.Arab Emir&quot;,&quot;NAMET RUB&quot;, 
&quot;Russian Fed.&quot;,&quot;NAMET RUB&quot;, 
&quot;Kazakhstan&quot;,&quot;NAMET RUB&quot;,
&quot;Ukraine&quot;,&quot;NAMET RUB&quot;,
&quot;Morocco&quot;,&quot;NAMET RUB&quot;,
&quot;Israel&quot;,&quot;NAMET RUB&quot;, 
&quot;Turkey&quot;,&quot;NAMET RUB&quot;, 
&quot;Bahrain&quot;,&quot;NAMET RUB&quot;, 
&quot;Oman&quot;,&quot;NAMET RUB&quot;, 
&quot;India&quot;,&quot;Fusion&quot;, 
&quot;Nepal&quot;,&quot;Fusion&quot;, 
&quot;Sri Lanka&quot;,&quot;Fusion&quot;,
NULL)</formula>
        <name>Region for WFR 2/2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_RejectedByEmail</fullName>
        <description>VPM - captures the email of approver</description>
        <field>VPM_RejectedByEmail__c</field>
        <formula>$User.Email</formula>
        <name>VPM-Rejected By Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VPM_StatusMDMRejected</fullName>
        <description>VPM - Used to set the status as &quot;Rejected&quot; when local MDM rejected Request</description>
        <field>VPM_Status__c</field>
        <literalValue>Master Data Management Rejected</literalValue>
        <name>VPM - Status MDM Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>VPM Reporting Region %281%2F2%29</fullName>
        <actions>
            <name>VPM_RegionForWFR12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the &apos;Reporting Region&apos; value when &apos;Country Requesting Vendor&apos; is changed as per region buckets defined by MDM Ops specifically:
- Europe
- North America
- Latin America
- South East Asia &amp; Australia
- Africa
Paired with VPM Reporting Region 2/2</description>
        <formula>IF(
OR(
VPM_CRVT__c=&quot;Austria&quot;,
VPM_CRVT__c=&quot;Belgium&quot;,
VPM_CRVT__c=&quot;Bulgaria&quot;,
VPM_CRVT__c=&quot;Czech Republic&quot;,
VPM_CRVT__c=&quot;Denmark&quot;,
VPM_CRVT__c=&quot;Estonia&quot;,
VPM_CRVT__c=&quot;Finland&quot;,
VPM_CRVT__c=&quot;France&quot;,
VPM_CRVT__c=&quot;Greece&quot;,
VPM_CRVT__c=&quot;Hungary&quot;,
VPM_CRVT__c=&quot;Ireland&quot;,
VPM_CRVT__c=&quot;Italy&quot;,
VPM_CRVT__c=&quot;Netherlands&quot;,
VPM_CRVT__c=&quot;Norway&quot;,
VPM_CRVT__c=&quot;Poland&quot;,
VPM_CRVT__c=&quot;Romania&quot;,
VPM_CRVT__c=&quot;Serbia&quot;,
VPM_CRVT__c=&quot;Slovakia&quot;,
VPM_CRVT__c=&quot;Spain&quot;,
VPM_CRVT__c=&quot;Switzerland&quot;,
VPM_CRVT__c=&quot;Sweden&quot;,
VPM_CRVT__c=&quot;United Kingdom&quot;,
VPM_CRVT__c=&quot;USA&quot;,
VPM_CRVT__c=&quot;Canada&quot;,
VPM_CRVT__c=&quot;Peru&quot;,
VPM_CRVT__c=&quot;Brazil&quot;,
VPM_CRVT__c=&quot;Mexico&quot;,
VPM_CRVT__c=&quot;El Salvador&quot;,
VPM_CRVT__c=&quot;Guatemala&quot;,
VPM_CRVT__c=&quot;Colombia&quot;,
VPM_CRVT__c=&quot;Ecuador&quot;,
VPM_CRVT__c=&quot;Dominican Rep.&quot;,
VPM_CRVT__c=&quot;Argentina&quot;,
VPM_CRVT__c=&quot;Nicaragua&quot;,
VPM_CRVT__c=&quot;Trinidad,Tobago&quot;,
VPM_CRVT__c=&quot;Costa Rica&quot;,
VPM_CRVT__c=&quot;Honduras&quot;,
VPM_CRVT__c=&quot;Venezuela&quot;,
VPM_CRVT__c=&quot;Chile&quot;,
VPM_CRVT__c=&quot;Paraguay&quot;,
VPM_CRVT__c=&quot;Panama&quot;,
VPM_CRVT__c=&quot;Uruguay&quot;,
VPM_CRVT__c=&quot;Thailand&quot;,
VPM_CRVT__c=&quot;Australia&quot;,
VPM_CRVT__c=&quot;Singapore&quot;,
VPM_CRVT__c=&quot;Myanmar&quot;,
VPM_CRVT__c=&quot;Philippines&quot;,
VPM_CRVT__c=&quot;Indonesia&quot;,
VPM_CRVT__c=&quot;New Zealand&quot;,
VPM_CRVT__c=&quot;Vietnam&quot;,
VPM_CRVT__c=&quot;Cambodia&quot;,
VPM_CRVT__c=&quot;Zambia&quot;,
VPM_CRVT__c=&quot;Kenya&quot;,
VPM_CRVT__c=&quot;Malawi&quot;,
VPM_CRVT__c=&quot;Uganda&quot;,
VPM_CRVT__c=&quot;Zimbabwe&quot;,
VPM_CRVT__c=&quot;Ivory Coast&quot;,
VPM_CRVT__c=&quot;Nigeria&quot;,
VPM_CRVT__c=&quot;Mozambique&quot;,
VPM_CRVT__c=&quot;South Africa&quot;,
VPM_CRVT__c=&quot;Ghana&quot;,
VPM_CRVT__c=&quot;Ethiopia&quot;,
VPM_CRVT__c=&quot;Tanzania&quot;
),	
TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Reporting Region %282%2F2%29</fullName>
        <actions>
            <name>VPM_RegionForWFR22</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the &apos;Reporting Region&apos; value when &apos;Country Requesting Vendor&apos; is changed as per region buckets defined by MDM Ops specifically:
-South Asia
-North Asia
-NAMET RUB
-Fusion
Paired with VPM Reporting Region 1/2</description>
        <formula>IF(
OR(
VPM_CRVT__c=&quot;Pakistan&quot;,
VPM_CRVT__c=&quot;Bangladesh&quot;,
VPM_CRVT__c=&quot;China &quot;,
VPM_CRVT__c=&quot;Japan&quot;,
VPM_CRVT__c=&quot;Taiwan&quot;,
VPM_CRVT__c=&quot;Hong Kong&quot;,
VPM_CRVT__c=&quot;Algeria&quot;,
VPM_CRVT__c=&quot;Bahrain&quot;,
VPM_CRVT__c=&quot;Egypt&quot;,
VPM_CRVT__c=&quot;Iran&quot;,
VPM_CRVT__c=&quot;Israel&quot;,
VPM_CRVT__c=&quot;Kazakhstan&quot;,
VPM_CRVT__c=&quot;Morocco&quot;,
VPM_CRVT__c=&quot;Oman&quot;,
VPM_CRVT__c=&quot;Russian Fed.&quot;,
VPM_CRVT__c=&quot;Saudi Arabia&quot;,
VPM_CRVT__c=&quot;Tunisia&quot;,
VPM_CRVT__c=&quot;Turkey&quot;,
VPM_CRVT__c=&quot;Utd.Arab Emir.&quot;,
VPM_CRVT__c=&quot;Ukraine&quot;,
VPM_CRVT__c=&quot;India &quot;,
VPM_CRVT__c=&quot;Nepal&quot;
),	
TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VPM Send email to Vendor</fullName>
        <actions>
            <name>VPM_SendEmailToVendorEmail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>VPM_Email_of_Webform_Sender</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_Set_Email_Flag_to_No</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VPM_Webform_sent_to_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_VendordoesntExistFlag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Sends email to Vendor with Webform details</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM Update Salesforce when request fails to submit to BPM</fullName>
        <actions>
            <name>VPM_UpdateStatusBPMSubmitFail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_MDMInsertUpdateStatus__c</field>
            <operation>equals</operation>
            <value>Failed to Submit to BPM</value>
        </criteriaItems>
        <description>Update status field in salesforce depending on MDM service call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VPM_EmailNotificationSAPBPMRejectedToMDM</fullName>
        <actions>
            <name>VPM_RequestRejectMDMNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VPM_PurchasingRequests__c.VPM_Status__c</field>
            <operation>equals</operation>
            <value>SAP BPM Approval Rejected</value>
        </criteriaItems>
        <description>Sent Email to MDM Ops User when Record is Rejected in SAP BPM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
