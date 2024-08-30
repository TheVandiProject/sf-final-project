import { createElement } from 'lwc';
import FeedbackForm from 'c/feedbackForm';
import LightningAlert from 'lightning/alert';

jest.mock('lightning/alert');

describe('c-feedback-form', () => {
    let element;

    beforeEach(() => {
        element = createElement('c-feedback-form', {
            is: FeedbackForm
        });
        document.body.appendChild(element);
    });

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('should call showAlert on handleSuccess with sample ID', async () => {
        LightningAlert.open = jest.fn().mockResolvedValue(true);

        const formElement = element.shadowRoot.querySelector('lightning-record-edit-form');
        const successEvent = new CustomEvent('success', {
            detail: { id: 'a00bm00000DQ06DAAT' }
        });
        formElement.dispatchEvent(successEvent);

        await Promise.resolve();

        expect(LightningAlert.open).toHaveBeenCalledWith(expect.objectContaining({
            message: 'Feedback record has been created successfully!',
            theme: 'success',
            label: 'Success!',
        }));
    });

    it('should enable the submit button after loading', () => {
        element.isLoading = false;
        const button = element.shadowRoot.querySelector('lightning-button');
        expect(button.disabled).toBe(false);
    });
});