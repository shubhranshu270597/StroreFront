import { api, LightningElement, track } from 'lwc';
import getOpportunitiesWithoutWarrantySupport from '@salesforce/apex/StoreFrontController.getOpportunitiesWithoutWarrantySupport';
import addForWarrantySupport from '@salesforce/apex/StoreFrontController.addForWarrantySupport'; 
export default class ShowWarrantySupport extends LightningElement {
    @api accountId;
    @track showPopup = { title: '', message: '', variant: '' };
    @api message;
    @api error;
    @track productsFound = false;
    @track products;
    @track prodId;
    
    connectedCallback(){
        if(this.accountId){
            this.getAllWarrantiesProduct();
        }
    }

    getAllWarrantiesProduct(){
        
        getOpportunitiesWithoutWarrantySupport({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    if(Array.isArray(result) && result.length){
                        this.productsFound = true;
                    }else{
                        this.productsFound = false;
                    }
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get products!',this.message,'error');
                    }else {
                        this.products= result;
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the products!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    addtoWarrantySupport(event){
        let productId = event.target.dataset.label;
        console.log('productId '+productId);
        if(productId){
            this.prodId = productId;
            addForWarrantySupport({ recordId: this.prodId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to add warranty support!',this.message,'error');
                    }else {
                        this.showHtmlMessage('Success!',this.message,'success');
                        this.getAllWarrantiesProduct();
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while adding warranty support!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
        }
    }
     // To show Toast message
	showHtmlMessage(title, message, variant) {
		this.showPopup.title = title;
		this.showPopup.message = message;
		this.showPopup.variant = variant;
		this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
	}
}