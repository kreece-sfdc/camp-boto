public with sharing class FitbitAuthHelper 
{
	public static string GenerateAuthUrl()
    {
        List<string> parts = new List<string>{ 'https://www.fitbit.com/oauth2/authorize?response_type=code' };
        parts.add('client_id=22D22N');
        parts.add('redirect_uri=https%3A%2F%2Ftest.salesforce.com%2Fapex%2Ffitbitauth');
        parts.add('scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight');
        parts.add('expires_in=604800');
        
		return string.join(parts, '&');
    }
    
    public static string GenerateBasicAuth()
    {
        string auth = '22D22N:04bb3168405ddb107087063cb5148b57';
        string encodedAuth = EncodingUtil.base64Encode(Blob.valueOf(auth));
        
        return encodedAuth;
    }
    
    public static void GetAccessToken(string code)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.fitbit.com/oauth2/token');
        req.setHeader('Authorization', 'Basic ' + GenerateBasicAuth());
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        List<string> parts = new List<string>();
        parts.add('client_id=22D22N');
        parts.add('redirect_uri=https%3A%2F%2Ftest.salesforce.com%2Fapex%2Ffitbitauth');
        parts.add('grant_type=authorization_code');
        parts.add('code=' + code);
        req.setBody(string.join(parts, '&'));
        
        Http api = new Http();
        HttpResponse res = api.send(req);
        
        if(res.getStatusCode() == 200)
        {
        	Map<string, object> resMap = (Map<string, object>)JSON.deserializeUntyped(res.getBody());
            
            string refresh_token = (string)resMap.get('refresh_token');
            string access_token = (string)resMap.get('access_token');
            string user = (string)resMap.get('user_id');
            
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            customMetadata.fullName = 'Auth_Storage.Fitbit';
            customMetadata.label = 'Fitbit';
            
            Metadata.CustomMetadataValue userField = new Metadata.CustomMetadataValue();
            userField.field = 'User__c';
            userField.value = user;
            customMetadata.values.add(userField);
            
            Metadata.CustomMetadataValue accessField = new Metadata.CustomMetadataValue();
            accessField.field = 'Access__c';
            accessField.value = access_token;
            customMetadata.values.add(accessField);
            
            Metadata.CustomMetadataValue refreshField = new Metadata.CustomMetadataValue();
            refreshField.field = 'Refresh__c';
            refreshField.value = refresh_token;
            customMetadata.values.add(refreshField);

            DeployMetadata.Deploy(customMetadata);
        }
    }
    
    public static void GetAccessTokenFromRefresh(string refresh_token)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.fitbit.com/oauth2/token');
        req.setHeader('Authorization', 'Basic ' + GenerateBasicAuth());
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=refresh_token&refresh_token=' + refresh_token);
        
        List<string> parts = new List<string>();
        parts.add('grant_type=refresh_token');
        parts.add('refresh_token=' + refresh_token);
        req.setBody(string.join(parts, '&'));
        
        Http api = new Http();
        HttpResponse res = api.send(req);
        
        if(res.getStatusCode() == 200)
        {
        	Map<string, object> resMap = (Map<string, object>)JSON.deserializeUntyped(res.getBody());
            
            string access_token = (string)resMap.get('access_token');
            
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            customMetadata.fullName = 'Auth_Storage.Fitbit';
            customMetadata.label = 'Fitbit';
            
            Metadata.CustomMetadataValue accessField = new Metadata.CustomMetadataValue();
            accessField.field = 'Access__c';
            accessField.value = access_token;
            customMetadata.values.add(accessField);
            
            DeployMetadata.Deploy(customMetadata);
        }
    }
}