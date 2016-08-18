<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FS_an_email_notification_for_any_changes_in_Status_of_Contract</fullName>
        <description>FS an email notification on rejected contract</description>
        <protected>false</protected>
        <recipients>
            <recipient>maha.r.bhaskar.reddy@accenture.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Contract_rejected_details</template>
    </alerts>
</Workflow>
