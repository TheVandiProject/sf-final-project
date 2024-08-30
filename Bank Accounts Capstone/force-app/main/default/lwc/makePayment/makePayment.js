import { LightningElement, api, track, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/MakePaymentController.getAccountDetails';
import makePayment from '@salesforce/apex/MakePaymentController.makePayment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class MakePayment extends LightningElement {
    @api recordId; 
    @track _remainingLoanAmount;
    @track _monthlyEMI;
    @track paymentSuccess = false;
    wiredAccountData;

    // Wire method to get account details
    @wire(getAccountDetails, { accountId: '$recordId' })
    wiredAccount(result) {
        this.wiredAccountData = result;
        if (result.data) {
            console.log('Account data:', result.data);
            this._remainingLoanAmount = result.data.Remaining_Loan_Amount__c;
            this._monthlyEMI = result.data.Monthly_EMI__c;
        } else if (result.error) {
            this.showToast('Error', result.error.body.message, 'error');
        }
    }

    // Getters to format values as currency
    get remainingLoanAmount() {
        return this.formatCurrency(this._remainingLoanAmount);
    }

    get monthlyEMI() {
        return this.formatCurrency(this._monthlyEMI);
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

    handleMakePayment() {
        makePayment({ accountId: this.recordId, emiAmount: this._monthlyEMI })
            .then(() => {
                this._remainingLoanAmount -= this._monthlyEMI;
                this.paymentSuccess = true;
                this.showToast('Success', 'Payment made successfully!', 'success');
                return refreshApex(this.wiredAccountData); 
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}