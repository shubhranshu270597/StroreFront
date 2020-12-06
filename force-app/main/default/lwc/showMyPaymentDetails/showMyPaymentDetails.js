import { api, LightningElement, track } from 'lwc';
import getPayments from '@salesforce/apex/StoreFrontController.getPayments';

export default class ShowMyPaymentDetails extends LightningElement {
    @api accountId;
    @track payments;
    @track showPopup = { title: '', message: '', variant: '' };
    @api message;
    @api error;
    
    connectedCallback(){
        if(this.accountId){
            console.log('accountId in showMyPayments '+this.accountId);
            this.getAllPayments();
        }
    }

    getAllPayments(){
        getPayments({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get Payments!',this.message,'error');
                    }else {
                        this.payments= result;
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the payments!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    // To show Toast message
	showHtmlMessage(title, message, variant) {
		this.showPopup.title = title;
		this.showPopup.message = message;
		this.showPopup.variant = variant;
		this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
	}
}