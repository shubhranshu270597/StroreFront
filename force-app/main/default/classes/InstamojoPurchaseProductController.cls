/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-28-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-26-2020   shubhranshu   Initial Version
**/
global class InstamojoPurchaseProductController {
    
    public InstamojoPurchaseProductController(){}

    @AuraEnabled
    public static String saveInstamojoResponse(String Amount, String Purpose,String buyer_name, String email, String phone, String recordId){  
        String result = '';
        try{
            result = sendInstaRequest(Amount,Purpose,buyer_name,email,phone,recordId);
        }catch(Exception e){
            System.debug('Error '+e.getMessage());
        }
        return result;
    }

    public static String sendInstaRequest(String Amount, String Purpose,String buyer_name, String email, String phone,String recordId){
        String apiKey=System.Label.InstamojoApiKey;
        String authtoken=System.label.InstamojoAuthToken;
        String redirectURL=System.label.redirectURL;
        String webhookAPI=System.label.InstamojoWebhookAPI;
        redirectURL = redirectURL + recordId;
        String Poststring = 'amount=' + Amount +  '&purpose=' + Purpose +  '&buyer_name=' + buyer_name + '&email=' + email +  '&phone=' + phone +  '&redirect_url=' + redirectURL +  '&allow_repeated_payments=false&send_email=true&send_sms=true&webhook='+webhookAPI;
        System.debug('Poststring-->'+Poststring);
        
        HttpRequest req=new HttpRequest();
        HttpResponse resp=new HttpResponse();
        Http http=new Http();
        
        req.setEndpoint('https://test.instamojo.com/api/1.1/payment-requests/');
        req.setMethod('POST');
        req.setHeader('X-Api-Key', apiKey);
        req.setHeader('X-Auth-Token', authtoken);
        req.setBody(Poststring); 
        System.debug(req);
        
        String status='';
        String result='';
        
        resp = http.send(req);
        Integer statusCode = resp.getStatusCode();                  
        if(statusCode == 201 || statusCode == 200){
            result = resp.getBody();
            System.debug('result --->'+result );
            Map<String,Object> mapOfResponseParameters = (Map<String,Object>)Json.deserializeuntyped(result);
            Map<String,Object> mapOfPaymentResponse =(Map<String,Object>)mapOfResponseParameters.get('payment_request');
            String paymentRequest=String.valueOf(mapOfResponseParameters.get('payment_request'));
            System.debug('paymentRequest-->'+paymentRequest);
            System.debug('mapOfResponseParameters -->'+mapOfResponseParameters);
            System.debug('mapOfPaymentResponse -->'+mapOfPaymentResponse);  
            if(!mapOfResponseParameters.isEmpty()){
                if(mapOfResponseParameters.containsKey('success')){
                    String currentStatus = String.valueOf(mapOfResponseParameters.get('success'));
                    String url=String.valueOf(mapOfPaymentResponse.get('longurl'));
                    System.debug('currentStatus-->'+currentStatus);
                    if(currentStatus=='true' && url!=''){
                        url=String.valueOf(mapOfPaymentResponse.get('longurl'));
                        String paymentId=String.valueOf(mapOfPaymentResponse.get('id'));
                        status=String.valueOf(mapOfPaymentResponse.get('status'));
                        String EmailStatus=String.valueOf(mapOfPaymentResponse.get('email_status'));
                        System.debug('url-->'+url+' status '+status + ' paymentId '+paymentId);
                        return url;
                    }
                    // else{
                    //     inst.ErrorStatus__c=String.valueOf(mapOfPaymentResponse.get('status'));
                    //     inst.ErrorMessage__c=String.valueOf(mapOfPaymentResponse.get('message'));        
                    //     insert inst;
                    // }
                }
                else{
                    result = 'Size zero';
                    System.debug('result-->'+result);
                    return '';
                }
            }
        }
        return '';
    } 
}
