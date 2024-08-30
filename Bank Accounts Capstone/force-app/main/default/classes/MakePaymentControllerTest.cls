@isTest
public class MakePaymentControllerTest {

    @testSetup
    static void setup() {
        // Create a test Account record 
        Account testAccount = new Account(
            Name = 'Test Account',
            Total_Loan_Amount__c = 10000,
            Loan_Interest_Rate__c = 5,
            Email__c = 'testing@yahoo.com'
        );
        insert testAccount;

        // Update the record because of trigger logic
        testAccount.Total_Loan_Amount__c = 10000;
        update testAccount;
    }

    @isTest
    static void testGetAccountDetails() {
        // Retrieve the test Account record's Id
        Account insertedAccount = [SELECT Id, Name, Total_Loan_Amount__c, Loan_Interest_Rate__c, 
                                   Monthly_EMI__c, Remaining_Loan_Amount__c 
                                   FROM Account LIMIT 1];

        // Call the getAccountDetails method
        Account result = MakePaymentController.getAccountDetails(insertedAccount.Id);

        // Validate the returned Account record
        System.assertNotEquals(null, result);
        System.assertEquals(insertedAccount.Id, result.Id);

        // Ensure Monthly_EMI__c and Remaining_Loan_Amount__c were calculated by the trigger
        System.assertNotEquals(null, result.Monthly_EMI__c);
        System.assertNotEquals(null, result.Remaining_Loan_Amount__c);
    }

    @isTest
    static void testMakePaymentSuccess() {
        // Retrieve the test Account record's Id and calculated fields
        Account insertedAccount = [SELECT Id, Remaining_Loan_Amount__c FROM Account LIMIT 1];

        // Check initial Remaining_Loan_Amount__c value
        Decimal initialRemainingLoanAmount = insertedAccount.Remaining_Loan_Amount__c;

        // Call the makePayment method with a valid EMI amount
        Decimal emiAmount = initialRemainingLoanAmount / 10; // Use a fraction of the remaining loan amount
        MakePaymentController.makePayment(insertedAccount.Id, emiAmount);

        // Retrieve the updated Account record
        Account updatedAccount = [SELECT Remaining_Loan_Amount__c FROM Account WHERE Id = :insertedAccount.Id];

        // Validate that the Remaining_Loan_Amount__c was correctly updated
        System.assertEquals(initialRemainingLoanAmount - emiAmount, updatedAccount.Remaining_Loan_Amount__c);
    }

    @isTest
    static void testMakePaymentExceedsLoanAmount() {
        // Retrieve the test Account record's Id and fields
        Account insertedAccount = [SELECT Id, Remaining_Loan_Amount__c FROM Account LIMIT 1];

        // Set emiAmount value higher than the remaining loan amount
        Decimal emiAmount = insertedAccount.Remaining_Loan_Amount__c + 1;

        try {
            // Call the makePayment method
            MakePaymentController.makePayment(insertedAccount.Id, emiAmount);
            System.assert(false, 'Expected an AuraHandledException to be thrown.');
        } catch (Exception e) {
            // Output the exception details 
            System.debug('Exception caught: ' + e.getMessage());
            
            System.assert(e instanceof AuraHandledException, 
                'Expected an AuraHandledException to be thrown, but caught: ' + e.getTypeName());
        }
    }
}