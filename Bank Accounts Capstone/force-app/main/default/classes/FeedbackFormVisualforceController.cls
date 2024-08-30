public class FeedbackFormVisualforceController {
    public void handleError() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while loading the feedback form.'));
    }
}