import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';

export default class FeedbackForm extends NavigationMixin(LightningElement) {
    @track isLoading = true;
    @track isSubmitted = false; // Flag to disable the form after submission

    connectedCallback() {
        this.isLoading = false;
    }

    handleSuccess() {
        this.isLoading = false;
        this.isSubmitted = true;
        const toastEvent = new ShowToastEvent({
            title: 'Success',
            message: 'Feedback record has been created successfully!',
            variant: 'success',
        });
        this.dispatchEvent(toastEvent);

        // Show alert pop-up
        this.showAlert();
    }

    handleError() {
        this.isLoading = false;
        const toastEvent = new ShowToastEvent({
            title: 'Error',
            message: 'An error occurred while creating the Feedback record.',
            variant: 'error',
        });
        this.dispatchEvent(toastEvent);
    }

    async showAlert() {
        await LightningAlert.open({
            message: 'Feedback record has been created successfully!',
            theme: 'success',
            label: 'Success!',
        });
    }
}