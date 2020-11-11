import { api, LightningElement, track } from 'lwc';
import getReferrals from '@salesforce/apex/StoreFrontController.getReferrals';
import saveReferral from '@salesforce/apex/StoreFrontController.saveReferral';
export default class ShowMyReferrals extends LightningElement {
    @api accountId;
    @api totalReferralPoints;
    @track referrals;
    @track showPopup = { title: '', message: '', variant: '' };
    @api message;
    @api error;
    @track referralFound = false;
    @track objReferrals = {Account__c:'', Name__c: '', Email_Id__c: '', MobileNumber__c: ''}

    connectedCallback(){
        if(this.accountId){
            this.getAllReferrals();
        }
    }

    getAllReferrals(){
        getReferrals({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    if(Array.isArray(result) && result.length){
                        this.referralFound = true;
                    }else{
                        this.referralFound = false;
                    }
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get Referrals!',this.message,'error');
                    }else {
                        this.referrals= result;
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the Referrals!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    handleName(event){
        let field = event.target.dataset.field;
        if ({}.hasOwnProperty.call(this.objReferrals, field)) {
			this.objReferrals[field] = event.detail.value;
			// this.customValidation(field);
		}
    }

    sendReferrals(event){
        if (!this.formValidate()) {
			return;
        }

        console.log('referrals '+JSON.stringify(this.objReferrals)+' account id '+this.accountId);
        this.objReferrals.Account__c = this.accountId;

        saveReferral({ referral: this.objReferrals, accountId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);                    
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to send referrals !',this.message,'error');
                    }else {
                        this.showHtmlMessage('Referral has been sent.',this.message,'success');
                        this.objReferrals.Name__c = '';
                        this.objReferrals.Email_Id__c = '';
                        this.objReferrals.MobileNumber__c = '';
                        this.objReferrals.Account__c = '';
                        this.getAllReferrals();
                        //this.dispatchEvent(new CustomEvent("referralevent"));
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while sending the referrals !', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    // to validate the form.
	formValidate() {
		const allValid = [
			...this.template.querySelectorAll('lightning-input, lightning-combobox, lightning-textarea')
		].reduce((validSoFar, inputCmp) => {
			inputCmp.reportValidity();
			return validSoFar && inputCmp.checkValidity();
		}, true);
		return allValid;
    }
     // To show Toast message
	showHtmlMessage(title, message, variant) {
		this.showPopup.title = title;
		this.showPopup.message = message;
		this.showPopup.variant = variant;
		this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
	}

}