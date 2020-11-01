import { api, LightningElement, track, wire } from 'lwc';
import getCustomerData from'@salesforce/apex/StoreFrontController.getCustomerData';
import getProductsData from '@salesforce/apex/StoreFrontController.getProductsData';
import addOrdersAndChecout from '@salesforce/apex/StoreFrontController.addOrdersAndChecout';

export default class StoreFrontMasterComponent extends LightningElement {

    @api parameters;
    @api recordId;
    @track pricebookname;
    @track products = [];
    @track showPopup = { title: '', message: '', variant: '' };
    @track calculation = {
        noOfItems : 0,
        amount : 0,
        show : false
    };
    @track allowProceed = false;
    @track customer ={
        Name: '',Email_Id__c :'',MobilePhone__c : '',Country__c: '',ShippingStreet:'',
        ShippingCity:'',ShippingState:'',ShippingCountry:'',ShippingPostalCode:'',User_Name__c : '',Password__c : ''
    }

    get options() {
		return [ { label: '1', value: '1' }, { label: '2', value: '2' } , { label: '3', value: '3' } ];
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

    @wire(getCustomerData, { recordId: '$recordId' })
	getCustomerDetails({ error, data }) {
		console.log('enter for get customer details ' + this.recordId);
		if (data) {
            for (const key in this.customer) {
                if ({}.hasOwnProperty.call(data, key)) {
                    this.customer[key] = data[key];
                }
            }
            if(this.customer.Country__c){
                if(this.customer.Country__c === 'India'){
                    this.pricebookname = 'Indian Price Book';
                }else if(this.customer.Country__c === 'United States'){
                    this.pricebookname = 'United State Price Book';
                }else if(this.customer.Country__c === 'Netherlands'){
                    this.pricebookname = 'Netherlands Price Book';
                } 
            }
            console.log(JSON.stringify(this.customer));
		} else if (error) {
			console.error(error);
		}
    }
    

    @wire(getProductsData, { PriceBookName: '$pricebookname' })
	getProductDetails({ error, data }) {
		console.log('enter for get product details ' + this.pricebookname);
		if (data) {
            var result = data.map(function(el) {
                var o = Object.assign({}, el);
                o.selected = false;
                o.quantity = 1;
                return o;
            })
            this.products = result;
            console.log(JSON.stringify(this.products));
		} else if (error) {
			console.error(error);
		}
    }

    handleClick(event) {
        let value = event.currentTarget.dataset.value;
        console.log('value ==> '+value);
        this.products.forEach(element => {
            if(element.Id === value) {
                if(element.selected) {
                    this.calculateTotalAmount(element.UnitPrice,'sub',0);
                    element.selected = false;
                    --this.calculation.noOfItems;
                }else if(!element.selected) {
                    this.calculateTotalAmount(element.UnitPrice,'add',0);
                    element.selected = true;
                    ++this.calculation.noOfItems;
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
        // if(event.target.name === 'Quantity') {
        //     let value = event.currentTarget.dataset.key;
        //     console.log('value ==> '+value);
        //     this.products.forEach(element => {
        //         if(element.Id === value) {
        //             console.log(element.quantity +' '+event.target.value);
        //             if(element.quantity === event.target.value){
        //                 console.log('Nothing to done here...');
        //             }else if(element.quantity < event.target.value){
        //                 this.calculateTotalAmount(element.UnitPrice,'add',event.target.value);                
        //             }else if(element.quantity > event.target.value){
        //                 this.calculateTotalAmount(element.UnitPrice,'sub',event.target.value);         
        //             }
        //             element.quantity = event.target.value;
        //         }
        //     });
        // }
    }

    SignOut(){
        var retVal = confirm("Are you sure want to Sign-Out ?");
        if( retVal == true ) {
           console.log("User wants to continue!");
           window.location.replace('/StoreFront/');
        } else {
           console.log("User does not want to continue!");
        }
    }
    
    calculateTotalAmount(UnitPriceAmount,operation,qty) {
        
        let totalamount = 0;
        console.log(qty);
        if(qty > 0){
            if(operation === 'add'){
                totalamount = parseFloat(this.calculation.amount) + parseFloat(UnitPriceAmount * qty);
            }else if(operation === 'sub'){
                totalamount = parseFloat(this.calculation.amount) - parseFloat(UnitPriceAmount * qty);
            }
        }else{
            if(operation === 'add'){
                totalamount = parseFloat(this.calculation.amount) + parseFloat(UnitPriceAmount);
            }else if(operation === 'sub'){
                totalamount = parseFloat(this.calculation.amount) - parseFloat(UnitPriceAmount);
            }
        }
        
        
        console.log('totalamount '+totalamount);
        this.calculation.amount = parseFloat(totalamount).toFixed(2);
        console.log('this.calculation.amount '+this.calculation.amount);
        if (this.calculation.amount === 0) {
            this.calculation.show = false;
        } else {
            this.calculation.show = true;
        }
    }

    checkOutandInsertOrders(){
        let prodList = [];
        this.products.forEach(element => {
            if(element.selected) {
                prodList = [...prodList,element.Product2.Name];
            }
        });

        addOrdersAndChecout({ accountId: this.recordId, productsName: prodList})
            .then((result) => {
                if (result != null) {
                    this.showHtmlMessage('Order added successfully.!', 'Order will deliver within 2-3 working days.' , 'success');
                    console.log('result '+JSON.stringify(result));
                }
            })
            .catch((error) => {
                this.showHtmlMessage('Error while updating the record!', 'error', 'error');
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