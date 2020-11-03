import { api, LightningElement, track } from 'lwc';
import saveCustomerDetails from '@salesforce/apex/StoreFrontLoginController.saveCustomerDetails';
import authenticateLogin from '@salesforce/apex/StoreFrontLoginController.authenticateLogin';
import My_Resource from '@salesforce/resourceUrl/StoreFrontLogo';

export default class StoreFrontLoginComponent extends LightningElement {

    logo = My_Resource ;
    @api greeting;
    @track showPopup = { title: '', message: '', variant: '' };
    @api customer ={
        Name: '',Email_Id__c :'',MobilePhone__c : '',Country__c: '',ShippingStreet:'',
        ShippingCity:'',ShippingState:'',ShippingCountry:'',ShippingPostalCode:'',User_Name__c : '',Password__c : ''
    }
    @api message;
    @api error;
    get countries() {
        return [
            { label: 'United States', value: 'United States' },
            { label: 'India', value: 'India' },
            { label: 'Netherlands', value: 'Netherlands' }
        ];
    }
    // Form input handle change event
	handleName(event) {
        let field = event.target.dataset.field;
        if ({}.hasOwnProperty.call(this.customer, field)) {
			this.customer[field] = event.detail.value;
			this.customValidation(field);
		}
    }

    customValidation(field){
        // if(field === 'User_Name__c' && this.customer[field] === 'test@gmail.com')  {
        //     console.log("username exist");
        // }
        if(field === 'Country__c'){
            this.customer.ShippingCountry = this.customer[field];
        }
    }

    saveCustomer() {
        // if (!this.formValidate()) {
		// 	return;
        // }
        
        console.log('customer '+JSON.stringify(this.customer));
        saveCustomerDetails({ account : this.customer})
            .then(result => {
                this.message = result;
                this.error = undefined;
                console.log("result", this.message);
                window.location.reload();
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                if(error.body.message.includes('duplicate value found: User_Name__c')){
                    this.showHtmlMessage(
                        'Error!',
                        'User Name is already taken',
                        'error'
                    );
                }else{
                    this.showHtmlMessage(
                        'Error creating record!',
                        error.body.message,
                        'error'
                    );
                }
                
                console.log("error", JSON.stringify(this.error));
            });
    }


    authLogin(){
        if (!this.formValidate()) {
			return;
        }
        
        console.log('customer '+JSON.stringify(this.customer));
        authenticateLogin({ username : this.customer.User_Name__c, password : this.customer.Password__c})
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message === 'error'){
                    this.showHtmlMessage(
                        'Error!',
                        'User not found',
                        'error'
                    );
                }else if(this.message === 'User Name or Password can not be empty...'){
                    this.showHtmlMessage(
                        'Warning!',
                        this.message,
                        'warning'
                    );
                }else{
                    window.location.replace("/StoreFront/StoreFrontHome?id="+this.message);
                }
                console.log("result", this.message);
                // window.location.reload();
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage(
                    'Error creating record!',
                    error.body.message,
                    'error'
                );
                console.log("error", JSON.stringify(this.error));
            });
    }
    // to validate the form.
	formValidate() {
		const allValid = [
			...this.template.querySelectorAll('lightning-input, lightning-combobox')
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