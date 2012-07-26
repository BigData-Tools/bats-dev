global class EmailProcessorTest implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          EmailTestObject__c emailTest = new EmailTestObject__c();
          emailTest.Test__c = email.plainTextBody;
          insert emailTest;
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          return result;
      }
  }