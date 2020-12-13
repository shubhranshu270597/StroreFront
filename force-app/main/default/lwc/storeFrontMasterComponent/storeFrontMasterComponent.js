import { api, LightningElement, track, wire } from 'lwc';
import getCustomerData from'@salesforce/apex/StoreFrontController.getCustomerData';
import getProductsData from '@salesforce/apex/StoreFrontController.getProductsData';
import addOrdersAndChecout from '@salesforce/apex/StoreFrontController.addOrdersAndChecout';
import getCustomerDetails from '@salesforce/apex/StoreFrontController.getCustomerDetails';
import updateCutsomerDetails from '@salesforce/apex/StoreFrontController.updateCutsomerDetails';
import saveInstamojoResponse from '@salesforce/apex/InstamojoPurchaseProductController.saveInstamojoResponse';
import savePayment from '@salesforce/apex/StoreFrontController.savePayment';
export default class StoreFrontMasterComponent extends LightningElement {

    @api parameters;
    @api recordId;
    @api paymentRequestId;
    @api paymentId;
    @api paymentStatus;
    @api totalReferralPoints;
    @track pricebookname;
    @track products = [];
    @track showPopup = { title: '', message: '', variant: '' };
    @track calculation = {
        noOfItems : 0,
        amount : 0,
        show : false
    };
    @track isModalOpen = false;
    @track dollarToInrCuurency;
    @track eurToInrCurrency;

    @track dashboardTabs ={
        showHome: true,
        showMyOrders: false,
        showMyComplaints: false,
        showMyWarrtiesProducts: false,
        showMyReferral: false,
        showMySpecialOffers: false,
        showMyPayments: false
    }
    @track allowProceed = false;
    @track indianFlag = false;
    @track usFlag = false;
    @track euroFlag = false;
    @track paymentMessageSection = false;
    @track updateEmailMobileSection = false;
    @track customerEmail;
    @track customerMobile;
    @track paymentMessage;
    @api message;
    @api error;
    @track customer ={
        Name: '',Email_Id__c :'',MobilePhone__c : '',Country__c: '',ShippingStreet:'',
        ShippingCity:'',ShippingState:'',ShippingCountry:'',ShippingPostalCode:'',User_Name__c : '',
        Password__c : '',Referral_Points__c:''
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
        if (Object.prototype.hasOwnProperty.call(this.parameters, 'payment_request_id')) {
			this.paymentRequestId = this.parameters.payment_request_id;
        }
        if (Object.prototype.hasOwnProperty.call(this.parameters, 'payment_id')) {
			this.paymentId = this.parameters.payment_id;
        }
        if (Object.prototype.hasOwnProperty.call(this.parameters, 'payment_status')) {
			this.paymentStatus = this.parameters.payment_status;
        } 
        if(this.paymentId && this.paymentRequestId && this.paymentStatus === 'Credit'){
            this.paymentMessage = 'Your last transaction was successfully paid, your unique reference id is '+this.paymentId;
            this.paymentMessageSection = true;
            this.callGetPaymentDetails();
        }else if (this.paymentId && this.paymentRequestId && this.paymentStatus !== 'Credit'){
            this.paymentMessage = 'Your last transaction was failed.';
            this.paymentMessageSection = true;
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
                    this.indianFlag = true;
                }else if(this.customer.Country__c === 'United States'){
                    this.pricebookname = 'United State Price Book';
                    this.usFlag = true;
                    this.getDollarToInrCurrency();
                }else if(this.customer.Country__c === 'Netherlands'){
                    this.pricebookname = 'Netherlands Price Book';
                    this.euroFlag = true;
                    this.isModalOpen = true;
                    this.getEurToInrCurrency();
                } 
            }
            if(this.customer.Referral_Points__c){
                this.totalReferralPoints = this.customer.Referral_Points__c;
            }

            if(this.customer.Email_Id__c === '' && this.customer.MobilePhone__c === ''){
                this.updateEmailMobileSection = true;
            }else{
                this.updateEmailMobileSection = false;
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
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to checkout!',this.message,'error');
                    }else {
                        this.showHtmlMessage('Order added successfully.!', 'Order will deliver within 2-3 working days.' , 'success');
                        this.redirectToPaymentGateway();
                        // window.location.reload();
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

    redirectToPaymentGateway(){
        let prodList = [];
        this.products.forEach(element => {
            if(element.selected) {
                prodList = [...prodList,element.Product2.Name];
            }
        });
        let prodName = prodList.join(", ");
        if(this.customer.Country__c === 'United States'){
            this.calculation.amount = parseFloat(this.dollarToInrCuurency * this.calculation.amount).toFixed(2);
        }else if(this.customer.Country__c === 'Netherlands'){
           this.calculation.amount = parseFloat(this.eurToInrCurrency * this.calculation.amount).toFixed(2);
        }
        saveInstamojoResponse({ Amount: this.calculation.amount, Purpose: prodName, buyer_name: this.customer.Name, email: this.customer.Email_Id__c, phone: this.customer.MobilePhone__c, recordId: this.recordId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    // if(this.message.includes('error')){
                    //     this.showHtmlMessage('Failed to redirect to gateway!','Error','error');
                    // }
                    // else {
                        
                    // }
                    // if(result){
                        window.location.replace(result);
                    // }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while redirecting!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    handleuserUpdateInfo(event){
        let value = event.target.value;
        let namedValue = event.currentTarget.dataset.name;
        console.log('value ==> '+value +' name ==>'+namedValue);
        if(namedValue === 'customerEmail' && value){
            this.customerEmail = value;
        }
        if(namedValue === 'customerMobile' && value){
            this.customerMobile = value;
        }
    }
    saveCustomerDetails(){
        console.log('customerEmail '+this.customerEmail +' customerMobile '+this.customerMobile);
        if(this.customerEmail && this.customerMobile){
                
            updateCutsomerDetails({ recordId: this.recordId , customerEmail: this.customerEmail, customerMobile: this.customerMobile})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message === 'success'){
                        this.showHtmlMessage('Customer Info updated successfully!', this.message, 'success');
                        window.location.reload();  
                    }
                    this.updateEmailMobileSection = !this.updateEmailMobileSection;
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while updating the record!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
        }else{
            this.showHtmlMessage('Mandatory Fields are missing!', 'Invalid Details', 'error');
        }
    }
    handleDashboardTabs(event){
        let value = event.currentTarget.dataset.value;
        console.log('value '+value);
        if(value === 'Home'){
            this.dashboardTabs.showHome = true;
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = false;
            this.dashboardTabs.showMySpecialOffers = false;
            this.dashboardTabs.showMyPayments = false;
        }else if(value === 'MyOrders'){
            this.dashboardTabs.showMyOrders = true;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = false;
            this.dashboardTabs.showMySpecialOffers = false;
            this.dashboardTabs.showMyPayments = false;
        }else if(value === 'Complaints'){
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = true;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = false;
            this.dashboardTabs.showMySpecialOffers = false;
            this.dashboardTabs.showMyPayments = false;
        }else if(value === 'WarrantySupport'){
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = true;
            this.dashboardTabs.showMyReferral = false;
            this.dashboardTabs.showMySpecialOffers = false;
            this.dashboardTabs.showMyPayments = false;
        }else if(value === 'Referrals'){
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = true;
            this.dashboardTabs.showMySpecialOffers = false;
            this.dashboardTabs.showMyPayments = false;
        }else if(value === 'SpecialOffers'){
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = false
            this.dashboardTabs.showMySpecialOffers = true; 
            this.dashboardTabs.showMyPayments = false;       
        }else if(value === 'Payments'){
            this.dashboardTabs.showMyOrders = false;
            this.dashboardTabs.showHome = false;
            this.dashboardTabs.showMyComplaints = false;
            this.dashboardTabs.showMyWarrtiesProducts = false;
            this.dashboardTabs.showMyReferral = false
            this.dashboardTabs.showMySpecialOffers = false;   
            this.dashboardTabs.showMyPayments = true;     
        }
    }

    closeModal(){
        this.isModalOpen = !this.isModalOpen;
    }
    
    closeModalForPayment(){
        this.paymentMessageSection = !this.paymentMessageSection;
    }
    
    // closeModalForUpdateDetails(){
    //     this.updateEmailMobileSection = !this.updateEmailMobileSection;
    // }

    getDollarToInrCurrency(){
        let request = new XMLHttpRequest();
        request.open("GET","https://api.exchangeratesapi.io/latest?base=USD");
        request.send();
        request.onload = () => {
            console.log(request);
            if(request.status === 200){
                let currentValues = JSON.parse(request.response);
                console.log(JSON.stringify(currentValues));
                this.dollarToInrCuurency = currentValues.rates.INR;
                console.log(JSON.stringify(this.dollarToInrCuurency));
            }else{
                console.log(`error ${request.status} ${request.statusText}`)
                this.showHtmlMessage('Error!', request.status +' '+request.statusText, 'error');
                
            }
        }

    }

    getEurToInrCurrency(){
        let request = new XMLHttpRequest();
        request.open("GET","https://api.exchangeratesapi.io/latest?base=EUR");
        request.send();
        request.onload = () => {
            console.log(request);
            if(request.status === 200){
                let currentValues = JSON.parse(request.response);
                console.log(JSON.stringify(currentValues));
                this.eurToInrCurrency = currentValues.rates.INR;
                console.log(JSON.stringify(this.eurToInrCurrency));
            }else{
                console.log(`error ${request.status} ${request.statusText}`)
                this.showHtmlMessage('Error!', request.status +' '+request.statusText, 'error');
                
            }
        }

    }

    callGetPaymentDetails(){
        if(this.paymentRequestId){
                
            savePayment({ paymentRequestId: this.paymentRequestId, paymentId: this.paymentId, recordId: this.recordId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message === 'Payment Inseted successfully' || this.message === 'Payment Updated successfully'){
                        this.showHtmlMessage('Success!', this.message, 'success');   
                    }else{
                        this.showHtmlMessage('Error!', this.message, 'error');
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while updating the record!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
        }else{
            this.showHtmlMessage('Payment Id is missing!', 'Something went wrong', 'warning');
        }

    }
    // handlereferralevent(){
    //     this.getCustomerDetails();
    // }
    // To show Toast message
	showHtmlMessage(title, message, variant) {
		this.showPopup.title = title;
		this.showPopup.message = message;
		this.showPopup.variant = variant;
		this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
    }
}