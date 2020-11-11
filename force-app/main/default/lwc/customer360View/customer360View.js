import { api, LightningElement, track } from 'lwc';
import authenticateLogin from '@salesforce/apex/StoreFrontLoginController.authenticateLogin';
import getCustomerDetails from '@salesforce/apex/StoreFrontController.getCustomerDetails';
import getOpportunities from '@salesforce/apex/StoreFrontController.getOpportunities';
import getCases from '@salesforce/apex/StoreFrontController.getCases';

export default class Customer360View extends LightningElement {
    @track username;
    @track password;
    @track showLoginPanel = true;
    @track informationCenter;
    @track showPopup = { title: '', message: '', variant: '' };
    @api accountId;
    @api parameters;
    @track accountFound = false;
   // @track ordersFound = false;
    @track complaintsFound = false;
    @api customer;
  //  @api orders;
    @api cases;
    @track message;
    @track error;
    @track totalproduct;
    @track totalbusiness;

    handleName(event){
        if(event.target.name === 'username'){
            this.username = event.target.value.trim();
        }else if(event.target.name === 'password'){
            this.password = event.target.value.trim();
        }
    }

    showCustomerDetails(){
        console.log(this.username +' '+ this.password);
        authenticateLogin({username : this.username,password : this.password})
        .then(result => {
            console.log('result  '+result);
            this.message = result;
            this.error = undefined;
            if(this.message.includes('error')){
                this.showHtmlMessage('Invalid Credentials !',this.message,'error');
            }else{
                this.accountId = result;
                this.showLoginPanel = false;
            }

            if(this.accountId){
                this.getCustomerDetails();
               // this.getOrderDetails();
                this.getAllCases();
            }
        })
        .catch(error => {
            this.error = error;
            this.message = undefined;
            console.log("error", error);
            this.showHtmlMessage('Invalid Credentials!','Please enter a valid UserName and Password.','error');
            this.showLoginPanel = true;
        });
    }

    getCustomerDetails(){
        getCustomerDetails({recordId : this.accountId})
        .then(result => {
            // console.log('result  '+JSON.stringify(result));
            // this.message = result;
            // this.error = undefined;
            this.accountFound = true;
            this.customer = result;
            console.log('customer '+JSON.stringify(this.customer)+' accountFound '+this.accountFound);
            this.totalproduct = this.customer[0].Total_Purchased_Item__c;
            this.totalbusiness = this.customer[0].Total_Revenue__c;
            console.log(this.totalproduct +' '+this.totalbusiness);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            console.log("error", error);
            this.showHtmlMessage('Failed to get customer details',error,'error');
        });
    }

    // getOrderDetails(){
    //     getOpportunities({ recordId: this.accountId})
    //         .then((result) => {
    //             if (result != null) {
    //                 this.message = result;
    //                 this.error = undefined;
    //                 console.log("result", this.message);
    //                 if(this.message.includes('error')){
    //                     this.showHtmlMessage('Failed to get Orders!',this.message,'error');
    //                 }else {
    //                     this.ordersFound = true;
    //                     this.orders= result;
    //                 }
    //             }
    //         })
    //         .catch((error) => {
    //             this.message = undefined;
    //             this.error = error;
    //             this.showHtmlMessage('Error while getting the orders!', this.error, 'error');
    //             console.log('error '+JSON.stringify(error));
    //         });
    // }

    getAllCases(){
        getCases({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    if(Array.isArray(result) && result.length){
                        this.complaintsFound = true;
                    }else{
                        this.complaintsFound = false;
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
     // To show Toast message
	showHtmlMessage(title, message, variant) {
		this.showPopup.title = title;
		this.showPopup.message = message;
		this.showPopup.variant = variant;
		this.template.querySelector('c-lwc-custom-toast').showCustomNotice();
	}

}