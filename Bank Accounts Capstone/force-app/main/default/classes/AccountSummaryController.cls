public with sharing class AccountSummaryController {
    @AuraEnabled(cacheable=true)
    public static Account getAccount(Id accountId) {
        Account account = [
            SELECT Id, Name, Total_Loan_Amount__c, Loan_Interest_Rate__c, Monthly_EMI__c, Remaining_Loan_Amount__c 
            FROM Account 
            WHERE Id = :accountId
        ];
        
        // Round the values to 2 decimal places
        // account.Monthly_EMI__c = roundToTwoDecimalPlaces(account.Monthly_EMI__c);
        // account.Remaining_Loan_Amount__c = roundToTwoDecimalPlaces(account.Remaining_Loan_Amount__c);
        
         return account;
    }
    
    public static Decimal roundToTwoDecimalPlaces(Decimal value) {
        if (value != null) {
            return value.setScale(2, RoundingMode.HALF_UP);
        }
        return null;
    }
}