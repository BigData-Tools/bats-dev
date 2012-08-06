<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>email_after_reject</fullName>
        <description>send_email_after_reject</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/reject_template</template>
    </alerts>
    <alerts>
        <fullName>send_email_after_reject</fullName>
        <description>send_email_after_reject</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Samples/SUPPORTSelfServiceResetPasswordSAMPLE</template>
    </alerts>
</Workflow>
