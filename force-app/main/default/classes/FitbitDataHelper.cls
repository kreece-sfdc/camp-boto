public with sharing class FitbitDataHelper 
{
	public static void GetTodaysActivity(string access_token, string user)
    {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.fitbit.com/1/user/' + user + '/activities/date/' + datetime.now().format('yyyy-MM-dd') + '.json');
        req.setHeader('Authorization', 'Bearer ' + access_token);
        
        Http api = new Http();
        HttpResponse res = api.send(req);
        
        if(res.getStatusCode() == 200)
        {
            system.debug(res.getBody());
        	Map<string, object> resMap = (Map<string, object>)JSON.deserializeUntyped(res.getBody()); 
        }
    }
}