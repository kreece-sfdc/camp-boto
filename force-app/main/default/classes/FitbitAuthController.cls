public class FitbitAuthController 
{
	public PageReference Redirect()
    {
        if(!ApexPages.currentPage().getParameters().containsKey('code'))
        {
            PageReference pr = new PageReference(FitbitAuthHelper.GenerateAuthUrl());
            pr.setRedirect(true);
            return pr;
        }
        else
        {
            string code = ApexPages.currentPage().getParameters().get('code');
            FitbitAuthHelper.GetAccessToken(code);
        }
        
        return null;
    }
}