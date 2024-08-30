public class AccountTriggerHandler {

    public static void calculateLoanInterestRate(List<Account> accounts) {
        // Query the RecordType information
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>(
            [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Account']
        );

        for (Account acc : accounts) {
            System.debug('Processing Account: ' + acc.Name);
            System.debug('RecordTypeId: ' + acc.RecordTypeId);
            System.debug('RecordType: ' + recordTypeMap.get(acc.RecordTypeId).DeveloperName);
            System.debug('Loan Type: ' + acc.Loan_Type__c);
            System.debug('Total Loan Amount: ' + acc.Total_Loan_Amount__c);

            if (acc.Loan_Type__c == null || acc.Total_Loan_Amount__c == null) {
                System.debug('Skipping due to null Loan Type or Total Loan Amount.');
                continue; // Skip if mandatory fields are not set
            }

            String recordTypeName = recordTypeMap.get(acc.RecordTypeId).DeveloperName;
            System.debug('Determined RecordTypeName: ' + recordTypeName);

            if (recordTypeName == 'Salary_Accounts' && acc.Loan_Type__c == 'Home Loan') {
                if (acc.Total_Loan_Amount__c <= 100000) {
                    acc.Loan_Interest_Rate__c = 8;
                } else if (acc.Total_Loan_Amount__c <= 500000) {
                    acc.Loan_Interest_Rate__c = 11;
                } else if (acc.Total_Loan_Amount__c <= 1000000) {
                    acc.Loan_Interest_Rate__c = 14;
                }
                System.debug('Calculated Loan Interest Rate for Salary Account - Home Loan: ' + acc.Loan_Interest_Rate__c);

            } else if (recordTypeName == 'Salary_Accounts' && acc.Loan_Type__c == 'Car Loan') {
                if (acc.Total_Loan_Amount__c <= 100000) {
                    acc.Loan_Interest_Rate__c = 8.4;
                } else if (acc.Total_Loan_Amount__c <= 500000) {
                    acc.Loan_Interest_Rate__c = 11.3;
                } else {
                    acc.addError('We do not provide a loan beyond 500000 for this type of account.');
                }
                System.debug('Calculated Loan Interest Rate for Salary Account - Car Loan: ' + acc.Loan_Interest_Rate__c);

            } else if (recordTypeName == 'Transactional_Accounts' && acc.Loan_Type__c == 'Home Loan') {
                if (acc.Total_Loan_Amount__c <= 100000) {
                    acc.Loan_Interest_Rate__c = 9;
                } else if (acc.Total_Loan_Amount__c <= 500000) {
                    acc.Loan_Interest_Rate__c = 11.8;
                } else if (acc.Total_Loan_Amount__c <= 1000000) {
                    acc.Loan_Interest_Rate__c = 15.9;
                }
                System.debug('Calculated Loan Interest Rate for Transactional Account - Home Loan: ' + acc.Loan_Interest_Rate__c);

            } else if (recordTypeName == 'Transactional_Accounts' && acc.Loan_Type__c == 'Car Loan') {
                if (acc.Total_Loan_Amount__c <= 100000) {
                    acc.Loan_Interest_Rate__c = 7;
                } else if (acc.Total_Loan_Amount__c <= 500000) {
                    acc.Loan_Interest_Rate__c = 10.9;
                } else if (acc.Total_Loan_Amount__c <= 1000000) {
                    acc.Loan_Interest_Rate__c = 13.6;
                }
                System.debug('Calculated Loan Interest Rate for Transactional Account - Car Loan: ' + acc.Loan_Interest_Rate__c);

            } else if (recordTypeName == 'Current_Account' && acc.Loan_Type__c == 'Home Loan') {
                if (acc.Total_Loan_Amount__c <= 1000000) {
                    acc.Loan_Interest_Rate__c = 10;
                } else if (acc.Total_Loan_Amount__c <= 5000000) {
                    acc.Loan_Interest_Rate__c = 12.5;
                } else if (acc.Total_Loan_Amount__c <= 10000000) {
                    acc.Loan_Interest_Rate__c = 16.2;
                }
                System.debug('Calculated Loan Interest Rate for Current Account - Home Loan: ' + acc.Loan_Interest_Rate__c);

            } else if (recordTypeName == 'Current_Account' && acc.Loan_Type__c == 'Car Loan') {
                if (acc.Total_Loan_Amount__c <= 1000000) {
                    acc.Loan_Interest_Rate__c = 9;
                } else if (acc.Total_Loan_Amount__c <= 5000000) {
                    acc.Loan_Interest_Rate__c = 11.9;
                } else if (acc.Total_Loan_Amount__c <= 10000000) {
                    acc.Loan_Interest_Rate__c = 14.6;
                }
                System.debug('Calculated Loan Interest Rate for Current Account - Car Loan: ' + acc.Loan_Interest_Rate__c);
            }
        }
    }

    public static void calculateInterest(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Account_Balance__c != null && acc.Interest_Rate__c != null) {
                System.debug('Current Savings Interest Rate ' + acc.Interest_Rate__c);
                acc.Calculated_Interest__c = acc.Account_Balance__c * (acc.Interest_Rate__c / 100);
                System.debug('Calculated Interest: ' + acc.Calculated_Interest__c);
            } else {
                acc.Calculated_Interest__c = 0; // Set to 0 if balance or interest rate is null
            }
        }
    }

    public static void calculateMonthlyEMI(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Total_Loan_Amount__c != null && acc.Loan_Interest_Rate__c != null && acc.Loan_Term__c != null) {
                Decimal principal = acc.Total_Loan_Amount__c;
                Decimal annualInterestRate = acc.Loan_Interest_Rate__c / 100;
                Decimal monthlyInterestRate = annualInterestRate / 12;
                Decimal loanTermInMonths = acc.Loan_Term__c;
    
                // Convert Decimal to Double for the Math.pow calculation
                Double monthlyInterestRateDouble = monthlyInterestRate.doubleValue();
                Double loanTermInMonthsDouble = loanTermInMonths.doubleValue();
    
                // Using Math.pow to calculate (1 + monthlyInterestRate)^loanTermInMonths
                Double expValueDouble = Math.pow(1 + monthlyInterestRateDouble, loanTermInMonthsDouble);
    
                // Convert result back to Decimal
                Decimal expValue = Decimal.valueOf(expValueDouble);
    
                // EMI Calculation
                Decimal emi = (principal * monthlyInterestRate * expValue) / (expValue - 1);
    
                acc.Monthly_EMI__c = emi;
                System.debug('Calculated Monthly EMI: ' + acc.Monthly_EMI__c);
            } else {
                acc.Monthly_EMI__c = 0; // Set to 0 if any value is null
            }
        }
    }

    public static void remainingLoanAmount(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Total_Loan_Amount__c != null && acc.Loan_Interest_Rate__c != null && acc.Loan_Term__c != null && acc.Monthly_EMI__c != null) {
                // Calculate total amount paid over the term
                Decimal totalPayments = acc.Monthly_EMI__c * acc.Loan_Term__c;
                
                // The remaining loan amount is the total payments made (including interest)
                acc.Remaining_Loan_Amount__c = totalPayments;
                System.debug('Calculated Remaining Loan Amount: ' + acc.Remaining_Loan_Amount__c);
            } else {
                acc.Remaining_Loan_Amount__c = 0; // Set to 0 if Loan or Loan Interest rate is null
            }
        }
    }
}