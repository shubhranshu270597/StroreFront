/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-28-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-27-2020   shubhranshu   Initial Version
**/
@RestResource(urlMapping='/getPaymentStatus/V.1.0/*')
global class StoreFrontPaymentWebhookAPI {
    
    @HttpPost
    global static List<MessageWrapper> getPaymentStatus(){
        List<MessageWrapper> lstmessageWrapper = new List<MessageWrapper>();
        String amount = '';
        String buyer = '';
        String buyer_name = '';
        String buyer_phone = '';
        String currencyCode = '';
        String fees = '';
        String longurl = '';
        String payment_id = '';
        String payment_request_id = '';
        String purpose = '';
        String shorturl = '';
        String status = '';
        String mac = '';

        MessageWrapper messageWrapper = null;

        RestRequest restReq = RestContext.request;
        RestResponse restRes = RestContext.response;
        // Reading parametrs from URL
        System.debug('restReq 1 '+restReq.headers.get('amount') +' '+restReq.headers.get('buyer'));
        System.debug('restReq 2 '+restReq.headers.get('buyer_name') +' '+restReq.headers.get('buyer_phone'));
        System.debug('restReq 3 '+restReq.headers.get('currency') +' '+restReq.headers.get('fees'));
        System.debug('restReq 4 '+restReq.headers.get('longurl') +' '+restReq.headers.get('payment_id'));
        System.debug('restReq 5 '+restReq.headers.get('payment_request_id') +' '+restReq.headers.get('purpose'));
        System.debug('restReq 6 '+restReq.headers.get('shorturl') +' '+restReq.headers.get('status')+' '+restReq.headers.get('mac'));
        
        amount = restReq.params.get('amount');
        buyer = restReq.params.get('buyer');
        buyer_name = restReq.params.get('buyer_name');
        buyer_phone = restReq.params.get('buyer_phone');
        currencyCode = restReq.params.get('currency');
        fees = restReq.params.get('fees');
        longurl = restReq.params.get('longurl');
        payment_id = restReq.params.get('payment_id');
        payment_request_id = restReq.params.get('payment_request_id');
        purpose = restReq.params.get('purpose');
        shorturl = restReq.params.get('shorturl');
        status = restReq.params.get('status');
        mac = restReq.params.get('mac');
        
        if(String.isBlank(amount)){
            messageWrapper = new MessageWrapper('501','amount is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(buyer)){
            messageWrapper = new MessageWrapper('501','buyer is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(buyer_name)){
            messageWrapper = new MessageWrapper('501','buyer_name is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(buyer_phone)){
            messageWrapper = new MessageWrapper('501','buyer_phone is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }else{
            buyer_phone = buyer_phone.replace('+91','');
        }
        if(String.isBlank(longurl)){
            messageWrapper = new MessageWrapper('501','longurl is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(payment_id)){
            messageWrapper = new MessageWrapper('501','payment_id is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(payment_request_id)){
            messageWrapper = new MessageWrapper('501','payment_request_id is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(purpose)){
            messageWrapper = new MessageWrapper('501','purpose is missing.');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }
        if(String.isBlank(status)){
            messageWrapper = new MessageWrapper('501','status is missing');
            lstmessageWrapper.add(messageWrapper);
            return lstmessageWrapper;
        }

        if(String.isNotBlank(buyer) && String.isNotBlank(buyer_phone)){
            List<Account> lstacc = [SELECT Id,Email_Id__c,MobilePhone__c from Account Where Email_Id__c=:buyer and MobilePhone__c=:buyer_phone order by CreatedDate desc LIMIT 1];
            List<Payment__c> lstPay = [SELECT Id,Account__c,Payment_Id__c,Payment_request_id__c,Payment_Status__c,Status__c from Payment__c Where Payment_request_id__c =:payment_request_id order by CreatedDate desc LIMIT 1];
            
            if(lstacc.size()>0 && lstPay.size() == 0){
                Payment__c payment = new Payment__c();
                payment.Account__c = lstacc[0].Id;
                payment.Amount__c = amount;
                payment.Currency__c = currencyCode;
                payment.fees__c = fees;
                payment.Longurl__c = longurl;
                payment.Mac_Id__c = mac;
                payment.Payment_For__c = purpose;
                payment.Payment_Id__c = payment_id;
                payment.Payment_request_id__c = payment_request_id;
                payment.Payment_Status__c = status =='Credit' ? 'Payment Made' : 'Transaction Failed'; 
                payment.Short_Url__c = shorturl;
                payment.Status__c = status;

                try {
                    insert payment;
                    messageWrapper = new MessageWrapper('200','Payment inserted successfully.');
                } catch (DMLException e) {
                    System.debug('Error '+e.getMessage());   
                    messageWrapper = new MessageWrapper('400','Error ->'+e.getMessage());
                    lstmessageWrapper.add(messageWrapper);
                    return lstmessageWrapper;
                }
            }else if(lstacc.size()>0 && lstPay.size()> 0){
                lstPay[0].Status__c = status;
                lstPay[0].Payment_Status__c = status == 'Credit' ? 'Payment Made' : 'Transaction Failed';

                try {
                    update lstPay;  
                    messageWrapper = new MessageWrapper('200','Payment updated successfully.');
                } catch (DMLException e) {
                    System.debug('Error '+e.getMessage());
                    messageWrapper = new MessageWrapper('400','Error ->'+e.getMessage());
                    lstmessageWrapper.add(messageWrapper);
                    return lstmessageWrapper;   
                }
            }else{
                messageWrapper = new MessageWrapper('502','record not found');
                lstmessageWrapper.add(messageWrapper);
                return lstmessageWrapper;
            }
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
