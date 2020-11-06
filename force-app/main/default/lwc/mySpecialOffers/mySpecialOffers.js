import { api, LightningElement, track, wire } from 'lwc';
import getProductBundlesData from '@salesforce/apex/StoreFrontController.getProductBundlesData';
import saveProductBundle from '@salesforce/apex/StoreFrontController.saveProductBundle'
export default class MySpecialOffers extends LightningElement {

    @track products = [];
    @api message;
    @api error;
    @track allowProceed = false;
    @track productName;
    @track productId;
    @api accountId;
    @track showPopup = { title: '', message: '', variant: '' };

    @wire(getProductBundlesData)
	getProductBundleDetails({ error, data }) {
		console.log('enter for get product bundle details');
		if (data) {
            var result = data.map(function(el) {
                var o = Object.assign({}, el);
                o.selected = false;
                return o;
            })
            this.products = result;
            console.log(JSON.stringify(this.products));
		} else if (error) {  
            this.message = undefined;
            this.error = error;
            this.showHtmlMessage('Error while getting the records!', this.error, 'error');
            console.log('error '+JSON.stringify(error));
		}
    }

    handleClick(event) {
        let value = event.currentTarget.dataset.value;
        console.log('value ==> '+value);
        this.products.forEach(element => {
            if(element.Id === value) {
                if(element.selected) {
                    element.selected = false;
                }else if(!element.selected) {
                    element.selected = true;
                    this.productName = element.Name;
                    this.productId = element.Id;
                }
            }
        });
    }

    handleChange(event){
        if(event.target.name === 'undertakingForCNXProducts'){
            if(event.target.checked){
                this.allowProceed = true;
            }else{
                this.allowProceed = false;
            }
        }
    }

    addProductBundle(){
        console.log(this.productId +' '+this.accountId);
        saveProductBundle({ prodId: this.productId, accountId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to add claim!',this.message,'error');
                    }else if(this.message.includes('already added')){
                        this.showHtmlMessage('Failed to add claim!',this.message,'warning');
                    }else {
                        this.showHtmlMessage('Offer Claim added successfully.!', 'Success' , 'success');
                        window.location.reload();
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while updating the record!', this.error, 'error');
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