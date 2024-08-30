@isTest
public class AccountSummaryControllerTest {
    

    
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
        
        // Optionally update the record if required to trigger logic
        testAccount.Total_Loan_Amount__c = 10000;
        update testAccount;
    }

    @isTest
    static void testGetAccount() {
        // Retrieve the test Account record's Id
        Account insertedAccount = [SELECT Id, Name, Total_Loan_Amount__c, Loan_Interest_Rate__c, Monthly_EMI__c, Remaining_Loan_Amount__c 
                                   FROM Account LIMIT 1];
        
        // Call the getAccount method
        Account result = AccountSummaryController.getAccount(insertedAccount.Id);
        
        // Validate that the returned Account record matches the test data
        System.assertNotEquals(null, result);
        System.assertEquals('Test Account', result.Name);
        System.assertEquals(10000, result.Total_Loan_Amount__c);
        System.assertEquals(5, result.Loan_Interest_Rate__c);

        // Assert the fields calculated by triggers
        System.assertNotEquals(null, result.Monthly_EMI__c); // Ensure it's calculated
        System.assertNotEquals(null, result.Remaining_Loan_Amount__c); // Ensure it's calculated
    }



    @isTest
    static void testRoundToTwoDecimalPlaces() {
        // Test the roundToTwoDecimalPlaces method
        Decimal originalValue = 123.4567;
        Decimal expectedValue = 123.46;
        
        Decimal result = AccountSummaryController.roundToTwoDecimalPlaces(originalValue);
        
        System.assertEquals(expectedValue, result);
        
         // Test the roundToTwoDecimalPlaces method with a null value
        Decimal nullValue = null;
        Decimal nullResult = AccountSummaryController.roundToTwoDecimalPlaces(nullValue);
        
        System.assertEquals(null, nullResult);  
    }
}