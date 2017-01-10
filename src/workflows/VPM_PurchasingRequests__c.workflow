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
        <fullName>VPM_SendEmailToVendorEmail</fullName>
        <description>VPM Send email to Vendor Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>supplier.information@unilever.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>VPM_ApprovalEmails/VPM_SendWebformToVendorVFTemplate</template>
    </alerts>
</Workflow>
