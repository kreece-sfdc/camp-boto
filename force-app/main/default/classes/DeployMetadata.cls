public class DeployMetadata 
{
    public static void Deploy(Metadata.CustomMetadata md) 
    {
        FitbitAuthCallBack callback = new FitbitAuthCallBack();
        
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        container.addMetadata(md);
        Metadata.Operations.enqueueDeployment(container, callback);
    }
}