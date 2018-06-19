public with sharing class BotDataHelper 
{
	public static void PublishEvent(string message_type, string message)
    {
        Bot_Data__e botData = new Bot_Data__e
            (
                Type__c = message_type,
                Message__c = message
            );
        
        EventBus.publish(botData);
    }
    
    public static void HandleTrigger(List<Bot_Data__e> items)
    {
        for(Bot_Data__e item : items)
        {
            system.debug('Type: ' + item.Type__c + ', Message: ' + item.Message__c);
        }
    }
}