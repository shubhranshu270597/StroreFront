/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 12-06-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-26-2020   shubhranshu   Initial Version
**/
global class InstamojoPurchaseProductController {
    
    public String fname {get;set;}
    public String lname {get;set;}
    public String uemail {get;set;}
    
    public InstamojoPurchaseProductController(){
        fname = '';
        lname = '';
        uemail = '';
    }

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
    webservice static String sendRefundRequest(String payment_id,String refund_amount){

        List<Payment__c> lstPay = [SELECT Id,Account__c,Payment_Id__c,Payment_request_id__c,Payment_Status__c,Status__c from Payment__c Where  Payment_Id__c=:payment_id order by CreatedDate desc LIMIT 1];
        
        String apiKey=System.Label.InstamojoApiKey;
        String authtoken=System.label.InstamojoAuthToken;
        String Poststring = '';
        if(String.isNotBlank(refund_amount)){
            Poststring = '{"transaction_id":"partial_refund_1","payment_id":\"'+payment_id+'\","type":"QFL","body":"Customer is not satisfied with the quality","refund_amount":\"'+refund_amount+'\"}';
            //Poststring = '{"payment_id":\"'+payment_id+'\","type":"QFL","refund_amount":\"'+refund_amount+'\"}';
        }else{
            // Poststring =  '{"payment_id":\"'+payment_id+'\","type":"QFL"}';
            Poststring = '{"transaction_id":"partial_refund_1","payment_id":\"'+payment_id+'\","type":"QFL","body":"Customer is not satisfied with the quality"}';
        }
        System.debug('Poststring-->'+Poststring);
        
        HttpRequest req=new HttpRequest();
        HttpResponse resp=new HttpResponse();
        Http http=new Http();
        
        req.setEndpoint('https://test.instamojo.com/api/1.1/refunds/');
        req.setHeader('content-type', 'application/json');
        req.setHeader('X-Api-Key', apiKey);
        req.setHeader('X-Auth-Token', authtoken);
        req.setBody(Poststring); 
        req.setMethod('POST');
        
        System.debug(req);
        
        String statusValue='';
        String result='';
        
        try {
            
            resp = http.send(req);
            result = resp.getBody();
                System.debug('result --->'+result );
            Integer statusCode = resp.getStatusCode();                  
            if((statusCode == 201 || statusCode == 200) && lstPay.size()> 0){
                result = resp.getBody();
                System.debug('result --->'+result );
                Map<String,Object> mapOfResponseParameters = (Map<String,Object>)Json.deserializeuntyped(result);
                Map<String,Object> mapOfRefundResponse =(Map<String,Object>)mapOfResponseParameters.get('refund');
                String successRequest=String.valueOf(mapOfResponseParameters.get('success'));
                System.debug('successRequest-->'+successRequest);
                System.debug('mapOfResponseParameters -->'+mapOfResponseParameters);
                System.debug('mapOfRefundResponse -->'+mapOfRefundResponse);  
                if(!mapOfResponseParameters.isEmpty()){
                    if(mapOfResponseParameters.containsKey('success')){
                        // String currentStatus = String.valueOf(mapOfResponseParameters.get('success'));
                        lstPay[0].Refund_Status__c = successRequest;
                        String status=String.valueOf(mapOfRefundResponse.get('status'));
                        if(status == 'Refunded'){
                            lstPay[0].Refunded__c = true;
                        }
                        lstPay[0].Instamojo_Refund_Response__c = String.valueOf(mapOfRefundResponse);
                        
                        try {
                            update lstPay;
                        } catch (DMLException e) {
                            System.debug('Error '+e.getMessage());
                        }

                        if(successRequest == 'true'){
                            statusValue = 'Refund done successfully.';
                        }else{
                            statusValue = 'Something went wrong.';
                        }
                    }
                    else{
                        statusValue = 'Size zero';
                        System.debug('statusValue-->'+statusValue);
                    }
                }
            } 
        }catch (Exception e) {
            System.debug(e.getMessage());
        }
        return statusValue;
    } 

    
    public PageReference facebookpplicationRequest(){
        
        String formDataURL = '/apex/FacebookPageData?client_id=727684621178135&redirect_uri=https://storefront-developer-edition.ap18.force.com/StoreFront/StoreFrontLogin&state={st=state123abc,ds=123456789}';
        
        PageReference pg = new PageReference(formDataURL);          
        pg.setRedirect(true);
        return pg;
    }

    public PageReference saveCNXStoreFrontUser(){
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String pwd = key.substring(0,len);
        Account acc = new Account();
        if(String.isNotBlank(fname) && String.isNotBlank(lname)){
            acc.Name = fname +' '+lname;
            acc.User_Name__c = fname+lname+'@cnxstorefront.com';
            acc.Country__c = 'India';
            acc.Password__c = pwd;
            acc.ShippingCity = 'test';
            acc.ShippingCountry = 'India';
            acc.ShippingState = 'test';
            acc.ShippingStreet = 'test';
            acc.ShippingPostalCode = '000000';
        }
        if(String.isNotBlank(uemail)){
            acc.Email_Id__c = uemail;
        }

        Map<String,String> mapofPriceBookIds = new Map<String,String>();
        for(Pricebook2 pb:[SELECT IsActive ,Description, IsStandard, Id, Name, SystemModstamp FROM Pricebook2 WHERE IsActive=True]){
            if(pb.NAME.contains('Netherlands')){
                mapofPriceBookIds.put('Netherlands',pb.Id);
            }
            if(pb.NAME.contains('Indian')){
                mapofPriceBookIds.put('India',pb.Id);
            }
            if(pb.NAME.contains('United State')){
                mapofPriceBookIds.put('United State',pb.Id);
            }
        }
        System.debug('mapofPriceBookIds '+mapofPriceBookIds);

        if(acc != null){
            try{    
                insert acc;
                System.debug('Account is inserted successfully...');
                Contract contract = new Contract();
                contract.AccountId = acc.Id;
                contract.BillingCity = acc.ShippingCity;
                contract.BillingCountry = acc.ShippingCountry;
                contract.BillingState = acc.ShippingState;
                contract.BillingStreet = acc.ShippingStreet;
                contract.BillingPostalCode = acc.ShippingPostalCode;
                contract.StartDate = date.today();
                contract.ContractTerm = 12;
                if(acc.ShippingCountry == 'Netherlands'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('Netherlands');
                }else if(acc.ShippingCountry == 'India'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('India');
                }else if(acc.ShippingCountry == 'United State'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('United State');
                }
                
                System.debug('contract '+contract);
                insert contract;
                System.debug('contract inserted successfully...');
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }

        String formDataURL = 'https://storefront-developer-edition.ap18.force.com/StoreFront/StoreFrontHome?id='+acc.Id;
        PageReference pg = new PageReference(formDataURL);          
        pg.setRedirect(true);
        return pg;
    }
}