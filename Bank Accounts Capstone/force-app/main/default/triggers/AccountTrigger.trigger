trigger AccountTrigger on Account (before insert, before update) {
    
    AccountTriggerHandler.calculateLoanInterestRate(Trigger.new);
    
    AccountTriggerHandler.calculateInterest(Trigger.new);

    AccountTriggerHandler.calculateMonthlyEMI(Trigger.new);

    if (Trigger.isInsert && Trigger.isBefore) {
        AccountTriggerHandler.remainingLoanAmount(Trigger.new);
    }

}