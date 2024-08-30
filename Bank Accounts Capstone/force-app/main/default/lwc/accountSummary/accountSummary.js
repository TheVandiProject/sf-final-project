import { LightningElement, track, wire, api } from 'lwc';
import getAccount from '@salesforce/apex/AccountSummaryController.getAccount';

export default class AccountSummary extends LightningElement {
    @api recordId; // Account Id passed from the Account record page
    @track isModalOpen = true; // Open modal by default when action is clicked
    @track accountData;

    @wire(getAccount, { accountId: '$recordId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountData = data;
        } else if (error) {
            console.error('Error fetching account data:', error);
            this.accountData = null; // Ensure no data is shown if there's an error
        }
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    get showModal() {
        return this.isModalOpen && this.accountData;
    }

    // Getter for formatted Total Loan Amount
    get formattedTotalLoanAmount() {
        return this.formatCurrency(this.accountData?.Total_Loan_Amount__c);
    }

    // Getter for formatted Monthly EMI
    get formattedMonthlyEMI() {
        return this.formatCurrency(this.accountData?.Monthly_EMI__c);
    }

    // Getter for formatted Remaining Loan Amount
    get formattedRemainingLoanAmount() {
        return this.formatCurrency(this.accountData?.Remaining_Loan_Amount__c);
    }

    // Utility function to format numbers as currency
    formatCurrency(amount) {
        if (amount !== undefined) {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD',
                minimumFractionDigits: 2,
            }).format(amount);
        }
        return '';
    }
}



// import { LightningElement, track, wire, api } from 'lwc';
// import getAccount from '@salesforce/apex/AccountSummaryController.getAccount';

// export default class AccountSummary extends LightningElement {
//     @api recordId; // Account Id passed from the Account record page
//     @track isModalOpen = true; // Open modal by default when action is clicked
//     @track accountData;

//     @wire(getAccount, { accountId: '$recordId' })
//     wiredAccount({ error, data }) {
//         if (data) {
//             this.accountData = data;
//         } else if (error) {
//             console.error('Error fetching account data:', error);
//             this.accountData = null; // Ensure no data is shown if there's an error
//         }
//     }

//     closeModal() {
//         this.dispatchEvent(new CustomEvent('close'));
        
//     }

//     get showModal() {
//         return this.isModalOpen && this.accountData;
//     }
// }