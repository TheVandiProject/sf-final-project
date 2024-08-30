@IsTest
public class AccountTriggerHandlerTest {

    @IsTest
    static void testSalaryAccountHomeLoan() {
        // Test Salary Account with Home Loan
        Account acc = new Account(
            Name = 'Test Salary Account',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salary_Accounts' LIMIT 1].Id,
            Loan_Type__c = 'Home Loan',
            Total_Loan_Amount__c = 150000,
            Account_Balance__c = 150000,
            Email__c = 'salary_home_loan@example.com'
        );
        insert acc;

        acc = [SELECT Loan_Interest_Rate__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(11, acc.Loan_Interest_Rate__c, 'Incorrect Loan Interest Rate for Salary Account Home Loan');
    }

    @IsTest
    static void testSalaryAccountCarLoan() {
        // Test Salary Account with Car Loan within range
        Account acc = new Account(
            Name = 'Test Salary Account Car Loan',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salary_Accounts' LIMIT 1].Id,
            Loan_Type__c = 'Car Loan',
            Total_Loan_Amount__c = 80000,
            Account_Balance__c = 80000,
            Email__c = 'salary_car_loan@example.com'
        );
        insert acc;

        acc = [SELECT Loan_Interest_Rate__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(8.4, acc.Loan_Interest_Rate__c, 'Incorrect Loan Interest Rate for Salary Account Car Loan');
    }

    @IsTest
    static void testSalaryAccountCarLoanBeyondLimit() {
        // Test Salary Account with Car Loan beyond limit
        Account acc = new Account(
            Name = 'Test Salary Account Car Loan Limit',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salary_Accounts' LIMIT 1].Id,
            Loan_Type__c = 'Car Loan',
            Total_Loan_Amount__c = 600000,
            Account_Balance__c = 600000,
            Email__c = 'salary_car_loan_limit@example.com'
        );

        Test.startTest();
        try {
            insert acc;
            System.assert(false, 'Expected an exception for exceeding loan limit');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('We do not provide a loan beyond 500000 for this type of account.'), 
                          'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    static void testTransactionalAccountHomeLoan() {
        // Test Transactional Account with Home Loan
        Account acc = new Account(
            Name = 'Test Transactional Account',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Transactional_Accounts' LIMIT 1].Id,
            Loan_Type__c = 'Home Loan',
            Total_Loan_Amount__c = 200000,
            Account_Balance__c = 200000,
            Email__c = 'transactional_home_loan@example.com'
        );
        insert acc;

        acc = [SELECT Loan_Interest_Rate__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(11.8, acc.Loan_Interest_Rate__c, 'Incorrect Loan Interest Rate for Transactional Account Home Loan');
    }

    @IsTest
    static void testCurrentAccountCarLoan() {
        // Test Current Account with Car Loan
        Account acc = new Account(
            Name = 'Test Current Account',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Current_Account' LIMIT 1].Id,
            Loan_Type__c = 'Car Loan',
            Total_Loan_Amount__c = 3000000,
            Account_Balance__c = 3000000,
            Email__c = 'current_car_loan@example.com'
        );
        insert acc;

        acc = [SELECT Loan_Interest_Rate__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(11.9, acc.Loan_Interest_Rate__c, 'Incorrect Loan Interest Rate for Current Account Car Loan');
    }

    @IsTest
    static void testBoundaryConditions() {
        // Test edge cases and boundary conditions
        Account acc = new Account(
            Name = 'Test Boundary Conditions',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Current_Account' LIMIT 1].Id,
            Loan_Type__c = 'Home Loan',
            Total_Loan_Amount__c = 1000000,
            Account_Balance__c = 1000000,
            Email__c = 'boundary_conditions@example.com'
        );
        insert acc;

        acc = [SELECT Loan_Interest_Rate__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(10, acc.Loan_Interest_Rate__c, 'Incorrect Loan Interest Rate for boundary condition');
    }

    // Add test methods for the new calculateMonthlyEMI method here
    @IsTest
    static void testCalculateMonthlyEMI() {
        Account acc = new Account(
            Name = 'Test EMI Calculation',
            RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Salary_Accounts' LIMIT 1].Id,
            Loan_Type__c = 'Car Loan',
            Total_Loan_Amount__c = 500000,
            Account_Balance__c = 500000,
            Email__c = 'emi_calculation@example.com'
        );
        insert acc;

        acc = [SELECT Monthly_EMI__c FROM Account WHERE Id = :acc.Id];
        System.assertNotEquals(null, acc.Monthly_EMI__c, 'Monthly EMI should be calculated');
    }
}