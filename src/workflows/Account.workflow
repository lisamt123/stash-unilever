<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FS_Account_Validation_Reject_From_Manager</fullName>
        <description>FS Account Validation Reject From Manager</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FS_Email_Templates/FS_Account_Validation_Reject_From_Manager</template>
    </alerts>
</Workflow>
