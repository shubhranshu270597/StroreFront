import { api, LightningElement, wire } from 'lwc';
import getCustomerData from'@salesforce/apex/StoreFrontController.getCustomerData';

export default class StoreFrontMasterComponent extends LightningElement {

    @api parameters;
    @api recordId;
    @api customer ={
        Name: '',Email_Id__c :'',MobilePhone__c : '',Country__c: '',ShippingStreet:'',
        ShippingCity:'',ShippingState:'',ShippingCountry:'',ShippingPostalCode:'',User_Name__c : '',Password__c : ''
    }

    connectedCallback(){
        // to set the recordId
        if(this.parameters){
            console.dir(this.parameters)
        }
		if (Object.prototype.hasOwnProperty.call(this.parameters, 'id')) {
			this.recordId = this.parameters.id;
        }
    }

    // to retrive the lead details on the basis of student no.
    @wire(getCustomerData, { recordId: '$recordId' })
	getCustomerDetails({ error, data }) {
		console.log('enter for get customer details ' + this.recordId);
		if (data) {
            for (const key in this.customer) {
                if ({}.hasOwnProperty.call(data, key)) {
                    this.customer[key] = data[key];
                }
            }
            console.log(JSON.stringify(this.customer));
		} else if (error) {
			console.error(error);
		}
	}
    
}