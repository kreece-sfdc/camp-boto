public class DeployMetadata 
{
    public static void Deploy(Metadata.CustomMetadata md) 
    {
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        container.addMetadata(md);
        Metadata.Operations.enqueueDeployment(container, null);
    }
}