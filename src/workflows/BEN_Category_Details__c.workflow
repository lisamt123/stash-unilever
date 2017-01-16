<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BENSend_Email_to_GPL</fullName>
        <description>BENSend Email to GPL</description>
        <protected>false</protected>
        <recipients>
            <recipient>BEN_GPL_User</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_Submitted_for_approval_GPL</template>
    </alerts>
    <alerts>
        <fullName>BENSend_Email_to_GPL_for_Delete</fullName>
        <description>BENSend_Email_to_GPL for Delete</description>
        <protected>false</protected>
        <recipients>
            <recipient>BEN_GPL_User</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BEN_Email_Templates/BEN_GPL_approval_for_deletion</template>
    </alerts>
</Workflow>
