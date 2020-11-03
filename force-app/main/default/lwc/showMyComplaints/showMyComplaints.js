import { api, LightningElement, track } from 'lwc';
import getCases from '@salesforce/apex/StoreFrontController.getCases';
import saveComplaints from '@salesforce/apex/StoreFrontController.saveComplaints';
export default class ShowMyComplaints extends LightningElement {

    @api accountId;
    @track cases;
    @track showPopup = { title: '', message: '', variant: '' };
    @api message;
    @api error;
    @track casesFound = false;
    @track objcase = {Subject: '', Priority: '', Description: ''}

    connectedCallback(){
        if(this.accountId){
            this.getAllCases();
        }
    }

    get PriorityList(){
        return [
            { label: 'High', value: 'High' },
            { label: 'Medium', value: 'Medium' },
            { label: 'Low', value: 'Low' }
        ];
    }
    getAllCases(){
        getCases({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    if(Array.isArray(result) && result.length){
                        this.casesFound = true;
                    }else{
                        this.casesFound = false;
                    }
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get Cases!',this.message,'error');
                    }else {
                        this.cases= result;
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the cases!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    handleName(event){
        let field = event.target.dataset.field;
        if ({}.hasOwnProperty.call(this.objcase, field)) {
			this.objcase[field] = event.detail.value;
			// this.customValidation(field);
		}
    }

    saveComplaint(){
        if (!this.formValidate()) {
			return;
        }

        console.log('cases '+JSON.stringify(this.objcase)+' account id '+this.accountId);

        saveComplaints({ caseobj: this.objcase, accountId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);                    
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get Cases!',this.message,'error');
                    }else {
                        this.showHtmlMessage('Complaint has been raised.',this.message,'success');
                        this.objcase.Subject = '';
                        this.objcase.Priority = '';
                        this.objcase.Description = '';
                        
                        this.getAllCases();
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the cases!', this.error, 'error');
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