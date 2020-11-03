import { api, LightningElement, track } from 'lwc';
import getOpportunities from '@salesforce/apex/StoreFrontController.getOpportunities';
export default class ShowMyOrders extends LightningElement {
    @api accountId;
    @track orders;
    @track showPopup = { title: '', message: '', variant: '' };
    @track orderNumber;
    @track MockCallForOrder = false;
    @track currentOrderStatus;
    @track orderStatus;
    @track deliveryStatus;
    @track success = false;
    @api message;
    @api error;
    
    connectedCallback(){
        if(this.accountId){
            console.log('accountId in showmyorders '+this.accountId);
            this.getAllOrders();
        }
    }


    getAllOrders(){
        getOpportunities({ recordId: this.accountId})
            .then((result) => {
                if (result != null) {
                    this.message = result;
                    this.error = undefined;
                    console.log("result", this.message);
                    if(this.message.includes('error')){
                        this.showHtmlMessage('Failed to get Orders!',this.message,'error');
                    }else {
                        this.orders= result;
                    }
                }
            })
            .catch((error) => {
                this.message = undefined;
                this.error = error;
                this.showHtmlMessage('Error while getting the orders!', this.error, 'error');
                console.log('error '+JSON.stringify(error));
            });
    }

    handleSelect(event){
        let ordernumber = event.target.dataset.label;
        console.log('ordernumber '+ordernumber);
        if(ordernumber){
            this.orderNumber = ordernumber;
            this.MockCallForOrder = true;
        }
    }

    getOrderStatus(){
        console.log('call get order status');
        // const userAction = async () => {
        //     const response = await fetch('https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getMyOrdersStatus/V.1.0/?orderId='+this.orderNumber, {
        //       method: 'POST',
        //     });
        //     console.log('response '+JSON.stringify(response));
        //     const myJson = await response.json(); //extract JSON from the http response
        //     // do something with myJson
        //     console.log('myJson '+myJson);
        //   }

        let request = new XMLHttpRequest();
        request.open("POST","https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getMyOrdersStatus/V.1.0/?orderId="+this.orderNumber);
        request.send();
        request.onload = () => {
            console.log(request);
            if(request.status === 200){
                console.log(JSON.parse(request.response));
                this.currentOrderStatus = JSON.parse(request.response);
                console.log(this.currentOrderStatus);
                this.success = true;
                if(this.currentOrderStatus[0].responseCode === '200'){
                    let result = this.currentOrderStatus[0].message.split("-");
                    console.log(result[0]+' '+result[1]);
                    this.orderStatus = result[0];
                    this.deliveryStatus = result[1];
                }else if(this.currentOrderStatus[0].responseCode === '502'){
                    this.showHtmlMessage('Error!', this.currentOrderStatus[0].message, 'error');
                }else if(this.currentOrderStatus[0].responseCode === '505'){
                    this.showHtmlMessage('Error!', this.currentOrderStatus[0].message, 'error');
                }
            }else{
                console.log(`error ${request.status} ${request.statusText}`)
                this.showHtmlMessage('Error!', request.status +' '+request.statusText, 'error');
                
            }
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