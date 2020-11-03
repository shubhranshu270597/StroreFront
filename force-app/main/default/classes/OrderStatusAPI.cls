/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-02-2020   shubhranshu   Initial Version
**/
@RestResource(urlMapping='/getMyOrdersStatus/V.1.0/*')
global class OrderStatusAPI {
    @HttpPost
    global static List<MessageWrapper> getOrderStatus(){
        List<MessageWrapper> lstmessageWrapper = new List<MessageWrapper>();
        String orderId = '';
        MessageWrapper messageWrapper = null;

        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        
        orderId = restReq.params.get('orderId');
        
        System.debug('orderId '+orderId);

        if(String.isNotBlank(orderId)){
            List<Opportunity> lst = [Select Id,Name,AccountId,Type,LeadSource,Order__c,Order_Status__c,PriceBook_Id__c,Order_Name__c,Product_Quantity__c,User_Email__c,
            OrderNumber__c,DeliveryInstallationStatus__c,Probability,StageName,CloseDate,ExpectedRevenue,Amount from Opportunity Where OrderNumber__c =:orderId Order by CreatedDate LIMIT 1];

            if(lst.size()>0){
                messageWrapper = new MessageWrapper('200',lst[0].Order_Status__c+'-'+lst[0].DeliveryInstallationStatus__c);
            }else{
                messageWrapper = new MessageWrapper('502','Order not found.');
                lstmessageWrapper.add(messageWrapper);
                return lstmessageWrapper;
            }
        }else{
            messageWrapper = new MessageWrapper('505','Order Id Can not be null.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }

        lstmessageWrapper.add(messageWrapper);
        return lstmessageWrapper;
    }

    global class MessageWrapper{

        public String responseCode;
        public String message;        
        global MessageWrapper(String responseCode,String message){
            this.responseCode = responseCode;
            this.message = message;
        }
    }
}