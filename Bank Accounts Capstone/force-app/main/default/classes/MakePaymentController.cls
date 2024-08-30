public with sharing class MakePaymentController {
    @AuraEnabled(cacheable=true)
    public static Account getAccountDetails(Id accountId) {
        return [SELECT Id, Remaining_Loan_Amount__c, Monthly_EMI__c FROM Account WHERE Id = :accountId];
    }

    @AuraEnabled
    public static void makePayment(Id accountId, Decimal emiAmount) {
        Account acc = [SELECT Id, Remaining_Loan_Amount__c FROM Account WHERE Id = :accountId];
        if (acc.Remaining_Loan_Amount__c >= emiAmount) {
            acc.Remaining_Loan_Amount__c -= emiAmount;
            System.debug('Updated Remaining Loan Amount: ' + acc.Remaining_Loan_Amount__c);
            
            update acc;
        } else {
            throw new AuraHandledException('EMI amount exceeds the remaining loan amount.');
        }
    }
}